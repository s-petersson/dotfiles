import { readlinkSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const RELOAD_COMMAND = "/dotfiles-theme-reload";
const POLL_INTERVAL_MS = 1000;

function readGeneration(currentTheme: string): string | undefined {
  try {
    return readlinkSync(currentTheme);
  } catch {
    return undefined;
  }
}

export default function (pi: ExtensionAPI) {
  let pollTimer: ReturnType<typeof setInterval> | undefined;

  pi.registerCommand("dotfiles-theme-reload", {
    description: "Reload pi after a dotfiles theme change",
    handler: async (_args, ctx) => {
      await ctx.reload();
      return;
    },
  });

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    const stateHome = process.env.XDG_STATE_HOME ?? join(homedir(), ".local", "state");
    const currentTheme = join(stateHome, "dotfiles", "theme", "current");
    const initialGeneration = readGeneration(currentTheme);
    let reloadQueued = false;

    pollTimer = setInterval(() => {
      const generation = readGeneration(currentTheme);
      if (!generation || generation === initialGeneration || reloadQueued) return;

      try {
        pi.sendUserMessage(RELOAD_COMMAND, {
          deliverAs: "followUp",
          expandPromptTemplates: true,
        });
        reloadQueued = true;
      } catch {
        // Retry on the next poll unless the session is shutting down.
      }
    }, POLL_INTERVAL_MS);
  });

  pi.on("session_shutdown", () => {
    if (pollTimer) clearInterval(pollTimer);
    pollTimer = undefined;
  });
}
