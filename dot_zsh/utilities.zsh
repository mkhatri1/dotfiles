# Auto run when dir is changed (zsh feature)
chpwd() {
  #set -- "$(git rev-parse --show-toplevel 2> /dev/null)"
  ## If cd'ing into a git working copy and not within the same working copy
  #if [ -n "$1" ] && [ "$1" != "$vc_root" ]; then
  #  vc_root="$1"
  #  git fetch
  #fi
  # ls inside folder after cd
  # eza --git --icons --classify --group-directories-first --time-style=long-iso --group --color-scale
}


vimBindingsHelp() {
    echo "Device Inventory List To Query::: %s/\(.*\S\)/('\1', '10', '1'), \n"
}
