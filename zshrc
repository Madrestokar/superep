HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

autoload -Uz colors && colors
PROMPT='%n@%m %1~ %# '

autoload -Uz compinit
compinit

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Tool name compatibility for Linux/macOS
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

if command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
elif command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -lah'
  alias tree='eza --tree'
else
  alias ll='ls -lah'
fi

alias grep='rg'

alias ls='eza'
alias ll='eza -lah'
alias tree='eza --tree'

sshf() {
    host=$(grep '^Host ' ~/.ssh/config | awk '{print $2}' | fzf)
    [ -n "$host" ] && ssh "$host"
}
