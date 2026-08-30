# AGENTS.md

Personal dotfiles repo. Keep changes simple, idempotent, and low-risk.

## Layout

- `home/` mirrors `$HOME` and is managed with GNU stow.
- `bin/` contains helper commands.
- `lib/dotfiles/` contains reusable shell helpers.
- `pre/` contains setup scripts that run before stow.
- `post/` contains setup scripts that run after stow.

## Commands

```sh
./bin/dot install             # pre setup, stow, post setup
./bin/dot pre                 # run pre-stow setup
./bin/dot stow                # stow home/ into $HOME
./bin/dot post                # run post-stow setup
```

## Setup conventions

- Name setup scripts with numeric prefixes: `10-*`, `20-*`, `30-*`.
- Use intermediate numbers like `15-*` only when inserting between phases.
- Setup scripts must be safe to re-run and avoid destructive changes.
- Do not run setup scripts unless explicitly asked.

Setup scripts run through `dotfiles-setup` receive:

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
