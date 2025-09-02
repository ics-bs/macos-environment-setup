# profiles/host/dotfiles/zsh/.zshrc content from canvas or profile specification.

# ~/.zshrc (managed via Stow)

# -------------------------------
# Basic environment
# -------------------------------
export PATH="/opt/homebrew/bin:$PATH"   # Homebrew (Apple Silicon default)
export EDITOR="vim"                     # Change to nano or code if you prefer

# -------------------------------
# Prompt
# -------------------------------
autoload -Uz promptinit; promptinit
prompt pure 2>/dev/null || prompt default

# -------------------------------
# Aliases
# -------------------------------
alias ll='ls -lah'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Quick access to iCloud
alias icloud='cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs"'

# -------------------------------
# cdpath (lets you do "cd iCloud")
# -------------------------------
# Add $HOME to cdpath so zsh will search ~ when you type "cd something"
cdpath=($HOME $cdpath)

# -------------------------------
# Plugins & tools
# -------------------------------
# Enable fzf keybindings if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# TheFuck (command correction, installed via brew)
eval $(thefuck --alias) 2>/dev/null

# z (directory jumping, installed via brew)
[ -f /opt/homebrew/etc/profile.d/z.sh ] && source /opt/homebrew/etc/profile.d/z.sh

# -------------------------------
# Customizations per machine
# -------------------------------
# Put any machine-specific tweaks in ~/.zshrc.local (ignored by Stow)
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
