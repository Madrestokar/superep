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

# fzf integration

if command -v brew >/dev/null 2>&1 && [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# Tool compatibility across macOS / Linux
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

if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi

sshf() {
  local host
  host=$(grep '^Host ' ~/.ssh/config 2>/dev/null | awk '{print $2}' | fzf)
  [ -n "$host" ] && ssh "$host"
}
