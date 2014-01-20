#
# dot zshrc
#
# snapcase 
#

# includes
function () {
  local f
  for f in $HOME/.zsh/*.zsh; do
    source $f
  done
}

# completion
autoload complist
autoload -U compinit
compinit

# escape followed by 'e' edits current command-line
autoload edit-command-line
zle -N edit-command-line
bindkey '\ee' edit-command-line

# options
setopt correct
setopt hist_ignore_all_dups
setopt autocd
setopt extended_glob
setopt extended_history
setopt append_history
setopt auto_resume
setopt auto_continue
setopt auto_pushd
setopt multios
setopt short_loops
setopt listpacked
setopt completeinword
setopt pushd_ignore_dups
setopt sharehistory
setopt hist_ignore_space
setopt interactivecomments
setopt dvorak

# history
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000

# styles
zstyle ':completion:*:descriptions' format '%U%B%d%b%u' 
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b' 
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# prompt
export PS1='%m:%(1j.%%%j:.)%1~%# '

# file mode creation mask
umask 022

# default editor
if [ -f /usr/bin/vim ] ; then
  export EDITOR=/usr/bin/vim
fi

# terminal title
case $TERM in
  xterm*|rxvt*|screen*)
    precmd() { print -Pn "\e]0;%m:%~\a" }
    preexec() { print -Pn "\e]0;%m:%~\a" }
    ;;
esac

# colored man-pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# various exports
export READNULLCMD=less                   # set zsh pager(<) to less
