# AGENTS.md

Personal dotfiles repo. Keep changes simple, idempotent, and low-risk.

## Layout

- `dot` is the repository command for installation and setup.
- `home/` mirrors `$HOME` and is managed with GNU stow.
- `lib/dotfiles/` contains reusable shell helpers.
- `pre/` contains setup scripts that run before stow.
- `post/` contains setup scripts that run after stow.

## Commands

```sh
./dot install                 # pre setup, stow, post setup
./dot pre                     # run pre-stow setup
./dot stow                    # stow home/ into $HOME
./dot post                    # run post-stow setup
```

## Setup conventions

- Put shared home files in `home/` and OS-only additions in `platform/<macos|arch>/home/`. `dot stow` selects the platform with `dotfiles_platform`.
- Keep platform trees additive: a platform file must not replace the same path under `home/`. For differing application settings, make the shared config optionally load a platform-only fragment.
- Name setup scripts with numeric prefixes: `10-*`, `20-*`, `30-*`.
- Use intermediate numbers like `15-*` only when inserting between phases.
- Setup scripts must be safe to re-run and avoid destructive changes.
- Do not run setup scripts unless explicitly asked.

Setup scripts run through `dot` receive:

- `DOTFILES_REPO`
- `DOTFILES_LIB`

Platform helpers:

```sh
source "${DOTFILES_LIB:?}/platform.sh"

dotfiles_is_macos
dotfiles_is_arch
dotfiles_platform
```

## Agent guidance

- Theming: read `docs/theming.md` before adding a theme or theming another tool.
- Prefer editing files under `home/` instead of directly editing `$HOME`.
- Keep secrets and machine-specific private values out of the repo.
- Prefer minimal, targeted edits.
- Prefer documenting manual steps over risky automation.
