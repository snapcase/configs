# extend path


function () {
  local pathdirs
  local ruby_version
  [[ -e =ruby ]] && ruby_version=$(ruby -e 'puts RUBY_VERSION')
  pathdirs=(
    $HOME/bin
  )
  [[ -n $ruby_version ]] && pathdirs+="${HOME}/.gem/ruby/${ruby_version}/bin"
  # prepend, don't append
  for dir in $pathdirs; do
    [ -d $dir ] && path[1,0]=$dir
  done
}
