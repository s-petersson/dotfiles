export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR="nvim"
export GIT_EDITOR="nvim"
bindkey -e

# Load Environment Variables
[[ -f "$XDG_CONFIG_HOME/.env" ]] && source "$XDG_CONFIG_HOME/.env"
[[ -f "$XDG_CONFIG_HOME/.env.secret" ]] && source "$XDG_CONFIG_HOME/.env.secret"

# User installed tools
export PATH="$HOME/.local/bin:$PATH"

# zsh options and completion
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

if [[ "$OSTYPE" == darwin* ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

eval "$(starship init zsh)"
eval "$(fnm env)"
eval "$(zoxide init zsh)"
export FZF_CTRL_R_OPTS="--reverse"
source <(fzf --zsh)

alias pi="PI_HARDWARE_CURSOR=1 pi"
alias vim=nvim

# aliases; commands
alias cat=bat
alias ls="eza -lah"
alias l="eza -lah"

# aliases; git
alias g="git"

# Here are some reasonable keybindings, for both smkx and rmkx key variants
bindkey '\e[H' beginning-of-line # Home
bindkey '\eOH' beginning-of-line # Home
bindkey '\e[F' end-of-line # End
bindkey '\eOF' end-of-line # End
bindkey '\e[D' backward-char # Left
bindkey '\eOD' backward-char # Left
bindkey '\e[C' forward-char # Right
bindkey '\eOC' forward-char # Right
bindkey '\e[3~' delete-char # Delete
bindkey '\e?' backward-delete-char # Backspace
bindkey '\e[5~' up-line-or-history # PageUp
bindkey '\e[6~' down-line-or-history # PageDown
bindkey '\e[1;5D' backward-word # Ctrl+Left
bindkey '\e[1;5C' forward-word # Ctrl+Right
bindkey '\e[Z' reverse-menu-complete # Shift+Tab

source $HOME/.zprofile-private
source $HOME/.zshrc-private

