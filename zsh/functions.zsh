mkcd() {
  test -z "$1" && echo >&2 "mkcd: no path given" && return
  test -d "$1" && echo >&2 "mkcd: Directory $1 already exists"
  mkdir -p -- "$1"
  cd -- "$1"
}

# http://www.zsh.org/mla/users/2003/msg00163.html
zcalc ()  { print $(( ans = ${1:-ans} )) }
zcalch () { print $(( [#16] ans = ${1:-ans} )) }
zcalcd () { print $(( [#10] ans = ${1:-ans} )) }
zcalco () { print $(( [#8] ans = ${1:-ans} )) }
zcalcb () { print $(( [#2] ans = ${1:-ans} )) }

q3s() {
  echo "\xff\xff\xff\xffgetstatus" | \
  socat - udp4:$1 2>/dev/null | \
  sed -e '1d' \
      -e '2s/\\\([^\]*\)\\\([^\]*\)/\1=\2\n/g' \
      -e 's/\^[0-9a-zA-Z]//g'
  return $pipestatus[2]
}

# vim:ft=zsh
