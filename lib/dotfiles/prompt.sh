#!/usr/bin/env bash

if [ -n "${DOTFILES_PROMPT_SH_LOADED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
DOTFILES_PROMPT_SH_LOADED=1

# Ask a yes/no question and return success for yes.
# Usage: dotfiles_confirm "Question?" [yes|no]
dotfiles_confirm() {
  local prompt="$1"
  local default_answer="${2:-no}"
  local suffix answer

  case "$default_answer" in
    y|Y|yes|Yes|YES)
      default_answer=yes
      suffix='[Y/n]'
      ;;
    n|N|no|No|NO)
      default_answer=no
      suffix='[y/N]'
      ;;
    *)
      echo "error: confirmation default must be 'yes' or 'no'" >&2
      return 2
      ;;
  esac

  while true; do
    printf '%s %s ' "$prompt" "$suffix" >&2
    if ! IFS= read -r answer 2>/dev/null </dev/tty; then
      answer="$default_answer"
      printf '\n' >&2
    fi

    case "$answer" in
      '') answer="$default_answer" ;;
    esac

    case "$answer" in
      y|Y|yes|Yes|YES) return 0 ;;
      n|N|no|No|NO) return 1 ;;
      *) echo "Please answer yes or no." >&2 ;;
    esac
  done
}
