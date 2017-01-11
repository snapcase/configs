# global aliases
alias -g ND='"$(print *(/om[1]))"'
alias -g NF='"$(print *(.om[1]))"'

# suffix aliases
alias -s PKGBUILD='vim'
alias -s {mkv,avi}='mplayer'
alias -s {jpg,jpeg,gif,png}='feh'

# shell
alias ..='cd ..'
alias j='jobs -l'
alias ss='source $HOME/.zshrc'
alias ls='ls --color -phF --group-directories-first'
alias ll='ls -l'
alias R='rehash'

alias a='cd $HOME/code/abs'
alias b='cd $HOME/bin'
alias k='cd $HOME/code/kernel'
alias c='cd $HOME/configs'
alias t='mkcd $HOME/mek/tmp'

# misc
alias share='python2 -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS"'
alias make='make -j3'
alias ud="sudo lsof | grep 'DEL.*lib' | awk '{print \$1 \" \" \$2}' | sort -u"

# apps
alias wget='wget -U Mozilla'
alias curl='curl -A Mozilla'
alias feh='feh -Frd'
alias mtr='mtr -t'
alias ri='ri -Tf ansi'
alias transmission='transmission-remote 127.0.0.1'

# vim:ft=zsh
