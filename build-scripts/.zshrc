export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="devcontainers"
zstyle ':omz:update' mode disabled  # disable automatic updates
plugins=(git)
source $ZSH/oh-my-zsh.sh

alias cl="clear"

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

## ls / l
alias l="ls -lah"
# quick search current dir, case insensitive (-i)
alias lsgrep='l | grep -i'
alias lgrep='l | grep -i'
alias grepl='l | grep -i'
alias grepls='l | grep -i'

## git
alias ga="git add"
alias gs="git status"
alias gp="echo use gpull or gpush"
alias gpull="git pull"
alias gpush="git push"
alias gc="git commit --verbose"
alias gcm="git commit --verbose -m \"~\""
alias gl="echo use gpull or gpush"
alias glog="git log --pretty=oneline --graph"
alias gr="git remote"
alias grv="git remote -vv"
unalias gg 2>/dev/null

## Path
HOMEBIN="${HOME}/bin"
export PATH="${HOMEBIN}:${PATH}"
export PATH="$PATH:${HOME}/.local/bin"
