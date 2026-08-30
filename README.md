# dotfiles

Personal dotfiles managed with GNU stow plus small idempotent setup scripts.

## Layout

```text
.
├── AGENTS.md
├── README.md
├── bin/
│   ├── dot
│   ├── dotfiles-stow
│   └── dotfiles-setup
├── home/
│   └── ... files mirroring $HOME ...
├── lib/
│   └── dotfiles/
│       └── platform.sh
└── setup/
    ├── pre/
    │   └── ... scripts run before stow ...
    └── post/
        └── ... scripts run after stow ...
```

The `home/` directory mirrors paths relative to `$HOME`.

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

## Private work overrides

An optional private repository can add work-only files and override public files. By default it is discovered next to this repository with a `-work` suffix:

```text
~/code/dotfiles/       # this public repository
~/code/dotfiles-work/  # private repository
```

The private repository uses the same `home/`, `setup/pre/`, and `setup/post/` layout. Running `dot install` in the public repository automatically:

1. runs public and then work pre-setup scripts;
2. stows public files, excluding paths supplied by the work repository;
3. stows work files; and
4. runs public and then work post-setup scripts.

Set an explicit location when the repositories are not siblings:

```sh
DOTFILES_WORK_REPO="$HOME/private/work-dotfiles" dot install
```

Set `DOTFILES_WORK_REPO` to an empty value to disable automatic discovery:

```sh
DOTFILES_WORK_REPO= dot install
```

The work repository's setup scripts receive `DOTFILES_REPO` pointing to the work repository and `DOTFILES_LIB` pointing to the shared helpers in this public repository.

## Setup scripts

Put imperative setup in `setup/pre/` or `setup/post/`. Scripts must be safe to re-run and should avoid destructive changes.

Scripts are run in lexical order, so use numeric prefixes:

```text
setup/pre/10-packages.sh
setup/pre/20-omarchy-packages.sh
setup/post/10-systemd-user.sh
setup/post/20-omarchy-reload.sh
```

`pre` and `post` is relative to `stow`. Meaning pre-stow scripts are for preparation before symlinks exist. Post-stow scripts are for activation/reload steps after symlinks exist.
