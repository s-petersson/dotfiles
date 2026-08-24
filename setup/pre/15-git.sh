#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/backup.sh"
source "${DOTFILES_LIB:?}/packages.sh"
source "${DOTFILES_LIB:?}/prompt.sh"

dotfiles_backup_file "$HOME/.config/git/config"

dotfiles_install_packages git openssh --macos gh --arch github-cli

personal_git_config="$DOTFILES_REPO/home/.config/git/config"
github_email="$(git config --file "$personal_git_config" --get user.email)"
key_file="$HOME/.ssh/id_ed25519_github_personal"
public_key_file="$key_file.pub"

github_auth_has_key_scope() {
  gh auth status --hostname github.com --json hosts \
    --jq '.hosts["github.com"][] | select(.active) | .scopes | split(", ") | index("admin:public_key") != null' \
    2>/dev/null | grep -qx true
}

if [ -f "$key_file" ] && [ -f "$public_key_file" ] && \
  gh auth status --hostname github.com >/dev/null 2>&1 && \
  github_auth_has_key_scope; then
  public_key="$(awk '{ print $1 " " $2 }' "$public_key_file")"
  if gh api user/keys --paginate --jq '.[].key' | grep -Fqx "$public_key"; then
    echo "==> Personal GitHub SSH access is already set up"
    exit 0
  fi
fi

if ! dotfiles_confirm "Set up personal GitHub SSH access?" no; then
  exit 0
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$key_file" ]; then
  echo "==> Generating a dedicated GitHub SSH key"
  ssh-keygen -t ed25519 -a 100 -C "$github_email" -f "$key_file"
else
  echo "==> GitHub SSH key already exists"
fi

if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "==> Authenticating with GitHub"
  gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key \
    --scopes admin:public_key
elif ! github_auth_has_key_scope; then
  echo "==> Authorizing GitHub SSH key access"
  gh auth refresh --hostname github.com --scopes admin:public_key
fi

public_key="$(awk '{ print $1 " " $2 }' "$public_key_file")"
if gh api user/keys --paginate --jq '.[].key' | grep -Fqx "$public_key"; then
  echo "==> GitHub already has this SSH key"
else
  echo "==> Uploading SSH key to GitHub"
  gh ssh-key add "$public_key_file" --title "$(hostname)-github"
fi
