dpicalc() {
  [ ! $# -eq 3 ] && echo "usage: $0 <current dpi> <sensitivity> <new dpi>" || echo $(( ($1./$3) * $2 ))
}

xkcd() {
  test -z $DISPLAY && return
  local a
  a=$(curl -s xkcd.com | \
    sed -n '/^<img/{s/.*\(http.*\)" title="\(.*\)" alt=".*/\1 \2/gp}' | \
    ruby -e 'require "cgi"; puts CGI.unescapeHTML gets')
  feh ${a%% *}; echo ${a#* }
}

mkcd() {
  test -z "$1" && echo >&2 "mkcd: no path given" && return
  test -d "$1" && echo >&2 "mkcd: Directory $1 already exists"
  mkdir -p -- "$1"
  cd -- "$1"
}

accuracy() {
  local name=$1
  test -z $name && name="snapcase"
  printf "%.2f%%\n" \
    $(( $(wget -qO- http://www.quakelive.com/profile/summary/$name | \
    sed -rn '/Shots:/ {s/,//g;s/.*Shots:<\/b>\s(.*)<br.*/\1.0/p}') * 100 ))
}

youtube() {
  local cookies url data
  url=$1; shift
  cookies=$(mktemp -d)/cookies.txt
  data=( ${(f)"$(youtube-dl --max-quality=22 --cookies $cookies --get-filename -g -e $url)"} )
  # $data is an array with 3 values, 1 = title, 2 = url, 3 = filename
  print "$data[1]\n"
  wget -qO- -U $(youtube-dl --dump-user-agent) \
    "http://gdata.youtube.com/feeds/api/videos/${data[3]%.*}?fields=media:group/media:description" | \
    sed 's/<[^>]*>//g'; print
  mplayer -really-quiet -cookies -cookies-file $cookies $data[2] "${@}"
  rm -r $cookies:h
}

# http://www.zsh.org/mla/users/2003/msg00163.html
zcalc ()  { print $(( ans = ${1:-ans} )) }
zcalch () { print $(( [#16] ans = ${1:-ans} )) }
zcalcd () { print $(( [#10] ans = ${1:-ans} )) }
zcalco () { print $(( [#8] ans = ${1:-ans} )) }
zcalcb () { print $(( [#2] ans = ${1:-ans} )) }

# vim:ft=zsh
