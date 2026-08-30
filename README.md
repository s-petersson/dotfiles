# dotfiles

Personal dotfiles managed with GNU stow plus small idempotent setup scripts.

## Layout

```text
.
├── AGENTS.md
├── README.md
├── bin/
│   └── ... commands for installing and managing the dotfiles ...
├── home/
│   └── ... files mirroring $HOME ...
├── lib/
│   └── dotfiles/
│       └── ... shell functions sourced by commands and setup scripts ...
├── pre/
│   └── ... scripts run before stow ...
└── post/
    └── ... scripts run after stow ...
```

The `home/` directory mirrors paths relative to `$HOME`.

The `bin/` directory contains the command entry points. `dot` dispatches user-facing commands, `dotfiles-setup` runs the public and private setup phases, and `dotfiles-stow` manages the GNU stow links and private overrides.

The `lib/dotfiles/` directory contains shell functions sourced by those commands and by setup scripts. They handle file backups, package installation, platform detection, private repository discovery, and confirmation prompts.

## Usage

```sh
./bin/dot install
```

After the first install, `dot` is available on `PATH`:

```sh
dot install
dot pre
dot stow
dot post
dot theme choose
dot help
```

## Private overrides

An optional private repository can add private files and override public files. It is discovered next to this repository with a `-private` suffix:

```text
~/code/dotfiles/       # this public repository
~/code/dotfiles-private/  # private repository
```

The private repository uses the same `home/`, `pre/`, and `post/` layout. Running `dot install` in the public repository automatically:

1. runs public and then private pre-setup scripts;
2. stows public files, excluding paths supplied by the private repository;
3. stows private files; and
4. runs public and then private post-setup scripts.

The private repository's setup scripts receive `DOTFILES_REPO` pointing to the private repository and `DOTFILES_LIB` pointing to the shared helpers in this public repository.

## Themes

A shared semantic palette can be switched on macOS and Omarchy. Theme-aware configuration is generated from that palette, while settings unrelated to color stay in the regular config files:

```sh
dot theme choose
dot theme set gruvbox
```

On Omarchy, selections from the native theme switcher use the same rendering flow. See [`docs/theming.md`](docs/theming.md) for the palette format, rendering model, and integration contract.

## Setup scripts

Put imperative setup in `pre/` or `post/`. Scripts must be safe to re-run and should avoid destructive changes.

Scripts are run in lexical order, so use numeric prefixes:

```text
pre/10-packages.sh
pre/20-omarchy-packages.sh
post/10-systemd-user.sh
post/20-omarchy-reload.sh
```

`pre` and `post` is relative to `stow`. Meaning pre-stow scripts are for preparation before symlinks exist. Post-stow scripts are for activation/reload steps after symlinks exist.
