# keys
bindkey '^f' forward-word
bindkey '^b' backward-word

bindkey "\e[1~" beginning-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[3~" delete-char

bindkey '^R' history-incremental-search-backward
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# mintty
if [[ $OS =~ "Windows" ]]; then
  bindkey '\e[H' beginning-of-line
  bindkey '\e[F' end-of-line
fi

