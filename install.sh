#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$repo/bin/dotfiles-setup" pre
"$repo/bin/dotfiles-stow"
"$repo/bin/dotfiles-setup" post
