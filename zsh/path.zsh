# extend path
function () {
  local pathdirs
  pathdirs=(
    $HOME/bin
    $HOME/.gem/ruby/2.0.0
  )
  # prepend, don't append
  for dir in $pathdirs; do
    [ -d $dir ] && path[1,0]=$dir
  done
}
