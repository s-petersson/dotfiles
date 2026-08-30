import { homedir } from "node:os";
import { basename } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const CACHE_TTL_MS = 5 * 60 * 1000;
const CACHE_UPDATE_INTERVAL_MS = 1000;
const OUTPUT_CHARACTERS_PER_TOKEN = 4;

type AgentState = "idle" | "working" | "waiting";
type SectionId =
  | "mode"
  | "cwd"
  | "branch"
  | "model"
  | "thinking"
  | "cache-timer"
  | "tokens-per-second"
  | "cost"
  | "context";

type Section = {
  id: SectionId;
  text: string;
};

const STATE_PRESENTATION = {
  idle: { color: "accent", label: "IDLE" },
  working: { color: "success", label: "WORK" },
  waiting: { color: "thinkingXhigh", label: "WAIT" },
} as const;

const THINKING_COLORS = {
  off: "thinkingOff",
  minimal: "thinkingMinimal",
  low: "thinkingLow",
  medium: "thinkingMedium",
  high: "thinkingHigh",
  xhigh: "thinkingXhigh",
  max: "thinkingMax",
} as const;

const SECTION_REMOVAL_ORDER: readonly SectionId[] = [
  "cwd",
  "branch",
  "cost",
  "tokens-per-second",
  "cache-timer",
  "thinking",
  "model",
];

function formatCost(cost: number): string {
  if (cost === 0) return "0";
  if (cost < 0.001) return "<0.001";
  return cost.toFixed(3);
}

function formatTokenCount(tokens: number): string {
  if (tokens >= 1_000_000) {
    return `${(tokens / 1_000_000).toFixed(1).replace(/\.0$/, "")}m`;
  }
  if (tokens >= 1_000) return `${Math.round(tokens / 1_000)}k`;
  return `${tokens}`;
}

function formatTokensPerSecond(tokensPerSecond: number | undefined): string {
  if (tokensPerSecond === undefined) return "-- tok/s";
  return `${tokensPerSecond.toFixed(1)} tok/s`;
}

function formatCacheTime(cacheExpiresAt: number | undefined): string {
  if (cacheExpiresAt === undefined) return "--:--";
  const secondsLeft = Math.max(
    0,
    Math.ceil((cacheExpiresAt - Date.now()) / 1000),
  );
  const minutes = Math.floor(secondsLeft / 60);
  const seconds = `${secondsLeft % 60}`.padStart(2, "0");
  return `${minutes}:${seconds}`;
}

function formatWorkingDirectory(cwd: string, width: number): string {
  if (width < 120) return basename(cwd);

  const home = homedir();
  if (cwd === home) return "~";
  if (cwd.startsWith(`${home}/`)) return `~${cwd.slice(home.length)}`;
  return cwd;
}

function totalWidth(left: Section[], right: Section[]): number {
  return (
    [...left, ...right].reduce(
      (total, section) => total + visibleWidth(section.text),
      0,
    ) + 1
  );
}

function removeOverflowingSections(
  left: Section[],
  right: Section[],
  width: number,
): void {
  for (const id of SECTION_REMOVAL_ORDER) {
    if (totalWidth(left, right) <= width) return;

    const group = left.some((section) => section.id === id) ? left : right;
    const index = group.findIndex((section) => section.id === id);
    if (index !== -1) group.splice(index, 1);
  }
}

export default function (pi: ExtensionAPI) {
  let state: AgentState = "idle";
  let tuiActive = false;
  let cacheExpiresAt: number | undefined;
  let cacheTimer: ReturnType<typeof setInterval> | undefined;
  let activeResponseStartedAt: number | undefined;
  let completedResponseMs = 0;
  let completedOutputTokens = 0;
  let activeOutputTokens = 0;
  let estimatedOutputCharacters = 0;
  let requestRender = () => {};

  const stopCacheTimer = () => {
    if (cacheTimer) clearInterval(cacheTimer);
    cacheTimer = undefined;
  };

  const startCacheTimer = () => {
    stopCacheTimer();
    if (!tuiActive || cacheExpiresAt === undefined) return;

    if (cacheExpiresAt <= Date.now()) {
      cacheExpiresAt = undefined;
      return;
    }

    cacheTimer = setInterval(() => {
      if (cacheExpiresAt !== undefined && cacheExpiresAt <= Date.now()) {
        cacheExpiresAt = undefined;
        stopCacheTimer();
      }
      requestRender();
    }, CACHE_UPDATE_INTERVAL_MS);
  };

  const resetResponseMetrics = () => {
    activeResponseStartedAt = undefined;
    completedResponseMs = 0;
    completedOutputTokens = 0;
    activeOutputTokens = 0;
    estimatedOutputCharacters = 0;
  };

  const tokensPerSecond = (): number | undefined => {
    const activeResponseMs = activeResponseStartedAt
      ? Date.now() - activeResponseStartedAt
      : 0;
    const responseSeconds = (completedResponseMs + activeResponseMs) / 1000;
    if (responseSeconds <= 0) return undefined;
    return (completedOutputTokens + activeOutputTokens) / responseSeconds;
  };

  const sessionCost = (ctx: ExtensionContext): number => {
    let cost = 0;
    for (const entry of ctx.sessionManager.getBranch()) {
      if (entry.type !== "message") continue;
      if (entry.message.role !== "assistant") continue;
      cost += entry.message.usage.cost.total;
    }
    return cost;
  };

  const updateState = (next: AgentState) => {
    state = next;
    requestRender();
  };

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    tuiActive = true;
    state = ctx.isIdle() ? "idle" : "working";
    resetResponseMetrics();
    cacheExpiresAt = undefined;

    for (const entry of ctx.sessionManager.getBranch()) {
      if (entry.type !== "message") continue;
      if (entry.message.role === "user") {
        completedResponseMs = 0;
        completedOutputTokens = 0;
        continue;
      }
      if (entry.message.role !== "assistant") continue;

      cacheExpiresAt = entry.message.timestamp + CACHE_TTL_MS;
      completedOutputTokens += entry.message.usage.output;
      completedResponseMs += Math.max(
        0,
        new Date(entry.timestamp).getTime() - entry.message.timestamp,
      );
    }

    startCacheTimer();

    ctx.ui.setFooter((tui, theme, footerData) => {
      requestRender = () => tui.requestRender();
      const unsubscribe = footerData.onBranchChange(requestRender);

      return {
        dispose() {
          unsubscribe();
          requestRender = () => {};
        },
        invalidate() {},
        render(width: number): string[] {
          const { color: stateColor, label: stateLabel } =
            STATE_PRESENTATION[state];
          const thinkingColor = THINKING_COLORS[ctx.thinkingLevel];
          const icon = (value: string) => theme.fg("dim", value);

          const cwd = formatWorkingDirectory(ctx.cwd, width);
          const branch = footerData.getGitBranch();
          const sessionName = pi.getSessionName();
          const model = ctx.model?.id ?? "no model";
          const provider = ctx.model
            ? theme.fg("muted", ` (${ctx.model.provider})`)
            : "";
          const usage = ctx.getContextUsage();
          const contextPercent =
            usage && ctx.model
              ? Math.min(
                  999,
                  Math.round((usage.tokens / ctx.model.contextWindow) * 100),
                )
              : 0;
          const contextWindow = ctx.model
            ? formatTokenCount(ctx.model.contextWindow)
            : "--";
          const currentTokensPerSecond = tokensPerSecond();
          const cost = sessionCost(ctx);

          const left: Section[] = [
            {
              id: "mode",
              text: theme.bg(
                "userMessageBg",
                `${theme.fg(stateColor, "▌")} ${theme.fg(stateColor, theme.bold(stateLabel))}  `,
              ),
            },
            {
              id: "cwd",
              text: theme.bg(
                "customMessageBg",
                `  ${icon("")}  ${theme.fg("text", cwd)}`,
              ),
            },
          ];
          if (branch) {
            left.push({
              id: "branch",
              text: theme.bg(
                "customMessageBg",
                `  ${icon("")}  ${theme.fg("text", branch)}`,
              ),
            });
          }
          left.push({
            id: "model",
            text: theme.bg(
              "customMessageBg",
              `  ${icon("󰚩")}  ${theme.fg("text", model)}${provider}`,
            ),
          });
          left.push({
            id: "thinking",
            text: theme.bg(
              "customMessageBg",
              `  ${icon("󰧑")}  ${theme.fg(thinkingColor, ctx.thinkingLevel)}`,
            ),
          });

          const right: Section[] = [];
          right.push({
            id: "cache-timer",
            text: theme.bg(
              "customMessageBg",
              ` ${icon("󰅐")}  ${theme.fg("text", formatCacheTime(cacheExpiresAt))} `,
            ),
          });
          right.push({
            id: "tokens-per-second",
            text: theme.bg(
              "customMessageBg",
              ` ${icon("󰓅")}  ${theme.fg("text", formatTokensPerSecond(currentTokensPerSecond))} `,
            ),
          });
          right.push({
            id: "cost",
            text: theme.bg(
              "userMessageBg",
              ` ${icon("")} ${theme.fg("text", formatCost(cost))} `,
            ),
          });
          right.push({
            id: "context",
            text: theme.bg(
              "userMessageBg",
              ` ${icon("")}  ${theme.fg("text", `${contextPercent}% / ${contextWindow}`)} ${theme.fg(stateColor, "▐")}`,
            ),
          });

          removeOverflowingSections(left, right, width);

          const leftText = left.map((item) => item.text).join("");
          const rightText = right.map((item) => item.text).join("");
          const padding = theme.bg(
            "customMessageBg",
            " ".repeat(
              Math.max(
                1,
                width - visibleWidth(leftText) - visibleWidth(rightText),
              ),
            ),
          );
          return [truncateToWidth(leftText + padding + rightText, width, "")];
        },
      };
    });
  });

  pi.on("agent_start", () => updateState("working"));
  pi.on("agent_settled", () => updateState("idle"));
  pi.on("ui_prompt_start", () => updateState("waiting"));
  pi.on("ui_prompt_end", (_event, ctx) =>
    updateState(ctx.isIdle() ? "idle" : "working"),
  );
  pi.on("model_select", () => requestRender());
  pi.on("thinking_level_select", () => requestRender());
  pi.on("session_info_changed", () => requestRender());
  pi.on("message_start", (event) => {
    if (event.message.role === "user") {
      resetResponseMetrics();
      requestRender();
      return;
    }
    if (event.message.role !== "assistant") return;

    cacheExpiresAt = event.message.timestamp + CACHE_TTL_MS;
    startCacheTimer();
    activeResponseStartedAt = Date.now();
    activeOutputTokens = 0;
    estimatedOutputCharacters = 0;
    requestRender();
  });
  pi.on("message_update", (event) => {
    if (event.message.role !== "assistant") return;

    const update = event.assistantMessageEvent;
    if (
      update.type === "text_delta" ||
      update.type === "thinking_delta" ||
      update.type === "toolcall_delta"
    ) {
      estimatedOutputCharacters += update.delta.length;
    }

    const reportedTokens = event.message.usage.output;
    activeOutputTokens =
      reportedTokens > 0
        ? reportedTokens
        : estimatedOutputCharacters / OUTPUT_CHARACTERS_PER_TOKEN;
    requestRender();
  });
  pi.on("session_shutdown", () => {
    tuiActive = false;
    stopCacheTimer();
    requestRender = () => {};
  });
  pi.on("message_end", (event) => {
    if (event.message.role === "assistant") {
      if (activeResponseStartedAt !== undefined) {
        completedResponseMs += Date.now() - activeResponseStartedAt;
      }
      completedOutputTokens += event.message.usage.output;
      activeResponseStartedAt = undefined;
      activeOutputTokens = 0;
      estimatedOutputCharacters = 0;
    }
    requestRender();
  });
}
