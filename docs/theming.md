# Theming

The theme system maps each theme's native colors onto shared UI roles and a terminal palette, then renders configuration for anything that needs it. Theme definitions are tracked in the repository. Generated configuration is runtime state and is not committed.

The flow is:

1. Select a theme.
2. Read and validate its semantic palette.
3. Render every template with that palette.
4. Atomically switch `~/.local/state/dotfiles/theme/current/` to the new output.
5. Notify running programs that need to reload.

A program integrates with the system by consuming a generated file or by inheriting colors from something that already does. This keeps color choices out of static configuration and avoids maintaining separate copies of the same palette.

## Commands

```sh
dotfiles-theme list
dotfiles-theme current
dotfiles-theme choose
dotfiles-theme set gruvbox
```

On Omarchy, `set` delegates to `omarchy theme set`. Omarchy's `theme-set` hook runs the renderer, so native theme selections and `dotfiles-theme` use the same flow. On macOS, `set` runs the renderer and changes the system appearance to match the palette's `mode`.

Generated files live under `~/.local/state/dotfiles/theme/current/`. Do not stow or commit that directory.

## Sources of truth

- `home/.config/dotfiles/themes/<slug>/colors.toml` defines the native palette, shared roles, and ANSI terminal colors.
- `home/.config/dotfiles/theme-templates/<output>.tpl` maps roles or terminal colors to a configuration format.
- `home/.local/bin/dotfiles-theme` validates palettes, renders templates, activates a generation, and reloads consumers.
- `home/.config/omarchy/themes/<slug>` makes a tracked theme available to Omarchy.
- `home/.config/omarchy/hooks/theme-set.d/dotfiles-theme` synchronizes Omarchy selections.
- `platform/macos/home/.local/bin/dotfiles-macos-appearance` synchronizes themes with the macOS appearance.
- `platform/macos/home/.config/dotfiles/macos-appearance.conf` sets the initial theme for each macOS appearance.
- `post/40-apply-theme.sh` reapplies the selected theme after stow. A new macOS installation uses the configured theme matching its current appearance.

The renderer can also use the active Omarchy theme's `colors.toml`. This lets untracked Omarchy themes pass through the same rendering pipeline.

## Palette contract

Every tracked theme sets `mode` to `dark` or `light` and has three tables. Themes linked into `~/.config/omarchy/themes/` also retain Omarchy's flat root keys as a compatibility projection:

- `[colors]` preserves the theme's native, named palette. Values are six-digit hex colors.
- `[roles]` maps shared visual purposes to names in `[colors]`.
- `[terminal]` maps the sixteen ANSI colors to names in `[colors]`.

A role or terminal mapping is a color name, not a copied hex value:

```toml
mode = "dark"

[colors]
base = "#1e1e2e"
surface0 = "#313244"
blue = "#89b4fa"

[roles]
background = "base"
surface = "surface0"
accent = "blue"

[terminal]
blue = "blue"
```

The shared role contract is:

```text
background background_secondary background_tertiary
surface surface_secondary surface_tertiary selection
overlay overlay_secondary overlay_tertiary
foreground_muted foreground_subtle foreground
accent accent_soft accent_warm
error error_muted warning success
info_muted info_bright info_soft
syntax_attribute syntax_constant syntax_operator syntax_string
```

The terminal contract is the ANSI names `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, and `white`, plus each `bright_` variant.

Role names describe purpose rather than luminance. For example, a light theme can make `surface_secondary` darker than `surface`, while a dark theme can make it lighter. Themes with smaller palettes may map several roles to the same native color. Add a role only when an application needs a new visual purpose; unused native colors remain in `[colors]` without becoming roles.

Templates use roles such as `{{ background }}`. Only terminal configuration uses tokens such as `{{ terminal_blue }}`. Templates do not use names from `[colors]`, which are intentionally theme-specific.

The renderer uses the structured tables when they are present. It also accepts an external Omarchy theme containing only the flat semantic format and converts it to the shared contract. Omarchy itself uses the flat compatibility projection in tracked themes.

To add a theme:

1. Add `home/.config/dotfiles/themes/<slug>/colors.toml` with all three tables and the complete contract.
2. If Omarchy should list it, add a relative link at `home/.config/omarchy/themes/<slug>` pointing to `../../dotfiles/themes/<slug>`.
3. Run `dotfiles-theme set <slug>` to validate and select it.
4. On Omarchy, run `omarchy theme set <slug>` and confirm the native switcher lists it.

A tracked theme may also contain a `backgrounds/` directory for platform-specific consumers. The portable renderer only reads `colors.toml`.

## macOS appearance

The macOS integration works in both directions. Selecting a theme changes the system appearance according to the palette's `mode`. Changing the appearance in System Settings, including with the automatic schedule, selects the last theme used for that mode.

The initial choices live in `~/.config/dotfiles/macos-appearance.conf`:

```sh
dark_theme=gruvbox
light_theme=gruvbox-light
```

Manual theme selections replace the remembered choice for their mode in runtime state. The tracked configuration remains the fallback for a new installation.

A LaunchAgent runs `dotfiles-macos-appearance watch`. The shell process checks the system mode once per second and synchronizes only when the mode changes. `post/45-start-macos-theme-listener.sh` loads the agent after stow.

## Adding an integration

First decide which system owns the colors. Do not generate configuration when the program can inherit the palette from an existing themed parent, such as a terminal. If another theme manager owns the program, integrate with that manager rather than overriding its output.

When generated configuration is needed:

1. Add `home/.config/dotfiles/theme-templates/<output>.tpl`. Use role tokens such as `{{ background }}`, or `{{ terminal_blue }}` when configuring an ANSI palette.
2. Make the program's static configuration load `~/.local/state/dotfiles/theme/current/<output>`. Keep settings unrelated to color in the static configuration.
3. If the program does not watch that file, add the smallest safe reload action to `reload_apps` in `home/.local/bin/dotfiles-theme`.
4. Apply every tracked theme and check each generated file for unresolved `{{ ... }}` tokens.
5. Test an existing process and a newly started process on every supported platform.

This is the whole integration contract: shared roles, a small format adapter, a stable runtime path, and an optional reload action.

## Verification

Use a temporary home when testing renderer changes so live configuration is not replaced:

```sh
tmp=$(mktemp -d)
HOME="$tmp" \
XDG_CONFIG_HOME="$PWD/home/.config" \
XDG_STATE_HOME="$tmp/state" \
DOTFILES_THEME_OMARCHY_HOOK=1 \
DOTFILES_THEME_NO_RELOAD=1 \
DOTFILES_THEME_NO_APPEARANCE=1 \
  ./home/.local/bin/dotfiles-theme set gruvbox

ls -1 "$tmp/state/dotfiles/theme/current"
! grep -R '{{.*}}' "$tmp/state/dotfiles/theme/current"
rm -rf "$tmp"
```

Also run `sh -n home/.local/bin/dotfiles-theme`. Test any reload action on a running process as well as a newly started one.
