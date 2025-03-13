export ZSH="$HOME/.zsh"
ZSH_THEME="mk"
zstyle ':omz:update' mode disabled  # disable automatic updates
plugins=(git)
# https://stackoverflow.com/questions/47745184
ZSH_CACHE="$HOME/.cache/zsh/"
if [[ ! -d $ZSH_CACHE ]]; then
  mkdir -p $ZSH_CACHE 
fi
ZSH_COMPDUMP="$ZSH_CACHE/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
HISTFILE="$ZSH_CACHE/zsh_history"
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
