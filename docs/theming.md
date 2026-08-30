# Theming

`dotfiles-theme` applies one semantic palette to shared tools on macOS and Omarchy. Theme definitions are tracked; rendered files are runtime state.

## Commands

```sh
dotfiles-theme list
dotfiles-theme current
dotfiles-theme choose
dotfiles-theme set gruvbox
```

On Omarchy, `set` delegates to `omarchy theme set`. Omarchy's `theme-set` hook then renders the shared tool configs, so the Omarchy theme switcher and the dotfiles command follow the same path. On macOS, `set` renders those configs directly.

Generated files live under `~/.local/state/dotfiles/theme/current/`. Do not stow or commit that directory.

## Sources of truth

- `home/.config/dotfiles/themes/<slug>/colors.toml` defines a complete palette.
- `home/.config/dotfiles/theme-templates/<output>.tpl` defines generated tool configuration.
- `home/.local/bin/dotfiles-theme` renders templates and reloads running tools.
- `home/.config/omarchy/themes/<slug>` exposes a tracked theme to Omarchy.
- `home/.config/omarchy/hooks/theme-set.d/dotfiles-theme` synchronizes Omarchy selections.
- `setup/post/40-apply-theme.sh` reapplies the selected theme after stow. A new macOS installation starts with Gruvbox.

The renderer can also consume the active Omarchy theme's `colors.toml`. This keeps shared tools synchronized when the user selects a stock Omarchy theme that is not tracked in this repository.

## Palette contract

Every tracked theme must have `mode`, set to `dark` or `light`, and all of these six-digit hex colors:

```text
accent selection muted
background dark_background darker_background lighter_background
foreground dark_foreground light_foreground bright_foreground
red yellow orange green cyan blue magenta brown
bright_red bright_yellow bright_green bright_cyan bright_blue bright_magenta
```

This is compatible with Omarchy's semantic `colors.toml` format. Keep tracked themes complete rather than relying on files from `/usr/share/omarchy`.

To add a theme:

1. Add `home/.config/dotfiles/themes/<slug>/colors.toml` with the complete palette.
2. Add the relative link `home/.config/omarchy/themes/<slug>` pointing to `../../dotfiles/themes/<slug>` if it should appear in Omarchy.
3. Run `dotfiles-theme set <slug>` to validate and select it.
4. On Omarchy, run `omarchy theme set <slug>` and confirm the graphical switcher lists it.

Backgrounds may live in the tracked theme's `backgrounds/` directory. Omarchy consumes them; the portable renderer ignores them.

## Adding support for a tool

First decide who owns the tool. Omarchy owns its shell, Hyprland, Linux desktop appearance, wallpaper transitions, and built-in platform integrations. The dotfiles renderer owns cross-platform tools and custom configuration.

For a renderer-owned tool:

1. Add `home/.config/dotfiles/theme-templates/<output>.tpl`. Use tokens such as `{{ background }}` from the palette contract.
2. Make the tool's static config optionally include `~/.local/state/dotfiles/theme/current/<output>`. Keep non-color settings in the static config.
3. Add the smallest safe live-reload command to `reload_apps` in `home/.local/bin/dotfiles-theme`. If the tool watches included files, no command is needed.
4. Apply both tracked themes and inspect the generated output for unresolved `{{ ... }}` tokens.
5. Test a running instance and a newly launched instance on each platform the tool supports.

Prefer ANSI color names for terminal children when they provide enough control. They inherit Ghostty's palette and need no generated file. Starship and the tmux window picker use this approach.

## Current integrations

- Ghostty optionally includes the generated `ghostty.conf`. Omarchy's generated Ghostty file loads first, and the shared palette loads last. The renderer sends `SIGUSR2` after replacing the shared file so running Ghostty instances reload it.
- tmux sources generated color options and reloads active sessions after a change. Run `dotfiles-theme set <theme>` before starting tmux.
- Neovim maps the semantic palette into the existing Catppuccin-based highlights. `dotfiles-theme` sends `SIGUSR1` to running Neovim processes. `:DotfilesThemeReload` is the manual fallback.
- Pi loads the generated `pi.json` as its `dotfiles` theme. A global extension watches theme selections and runs pi's reload flow so existing transcript components are rendered again with the new colors.
- Starship uses ANSI names and follows the terminal palette without rendering.

## Verification

Use a temporary home when testing renderer changes so tracked or live configuration is not replaced:

```sh
tmp=$(mktemp -d)
HOME="$tmp" \
XDG_CONFIG_HOME="$PWD/home/.config" \
XDG_STATE_HOME="$tmp/state" \
DOTFILES_THEME_OMARCHY_HOOK=1 \
DOTFILES_THEME_NO_RELOAD=1 \
  ./home/.local/bin/dotfiles-theme set gruvbox

ls -1 "$tmp/state/dotfiles/theme/current"
rm -rf "$tmp"
```

Also run `sh -n home/.local/bin/dotfiles-theme` and start Neovim headlessly after changes to its integration.
