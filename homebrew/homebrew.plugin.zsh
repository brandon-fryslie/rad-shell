# Plugin for ensuring homebrew is installed

install_cmd='/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
brew_bin=/usr/local/bin/brew

if [[ $(uname) == 'Darwin' ]]; then
  if [[ -x $brew_bin ]]; then
    export PATH="/usr/local/bin:$PATH"
  else
    echo "Installing Homebrew with command ${install_cmd}"
    $install_cmd
  fi
fi
