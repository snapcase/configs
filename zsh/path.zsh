# extend path

function () {
  local pathdirs
  local gem_path
  which gem &>/dev/null
  [ $? -eq 0 ] && gem_path="$(gem env gempath | cut -d: -f1)"
  pathdirs=(
    $HOME/bin
  )
  [ -n $gem_path ] && pathdirs+="${gem_path}/bin"
  # prepend, don't append
  for dir in $pathdirs; do
    [ -d $dir ] && path[1,0]=$dir
  done
}
