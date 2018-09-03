#!/bin/bash

case "$(uname)" in
  Linux)
    # Basic packages
    sudo apt update
    sudo apt install -y \
      curl \
      wget

    #
    # Repositories
    #
    # Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    # Node.js
    curl -fsSL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    # Yarn
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb [arch=amd64] https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    # Spotify
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
    echo "deb [arch=amd64] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    # Chrome
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    # VirtualBox
    sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
    # Atom
    sudo add-apt-repository ppa:webupd8team/atom

    # Update / upgrade
    sudo apt update
    sudo apt dist-upgrade -y

    # Purge
    sudo apt purge -y \
      apport \
      docker \
      docker-engine \
      docker.io \
      cmdtest \
      nodejs \
      chromium-* \
      virtualbox

    # Install
    sudo apt install -y \
      curl \
      git \
      wget \
      exfat-fuse \
      exfat-utils \
      zsh \
      vim \
      vim-gnome \
      gnupg-agent \
      tilix \
      lynx \
      neomutt \
      urlview \
      tmux \
      xsel \
      filezilla \
      transmission \
      vlc \
      steam \
      apt-transport-https \
      ca-certificates \
      software-properties-common \
      docker-ce \
      gcc \
      g++ \
      make \
      build-essential \
      nodejs \
      yarn \
      awscli \
      spotify-client \
      google-chrome-stable \
      dkms \
      virtualbox \
      virtualbox-ext-pack \
      vagrant \
      atom \
      shellcheck \
      ruby \
      fonts-hack-ttf

    # Atom packages
    apm install \
      sync-settings

    # Node.js packages
    sudo yarn global add \
      eslint --ignore-optional

    # Hack Nerd Font
    mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
    curl -fLo "Hack Regular Nerd Font Complete.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf
    sudo fc-cache -fv

    ;;
  Darwin)
    # xCode
    xcode-select -p || exit 1
    sudo xcodebuild -license accept
    sudo xcode-select --install

    # Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor

    # Taps
    brew tap \
      caskroom/cask \
      buo/cask-upgrade \
      caskroom/drivers \
      caskroom/fonts

    # Bottles
    brew install \
      awscli \
      curl \
      git \
      gpg \
      lynx \
      mas \
      neomutt/homebrew-neomutt/neomutt \
      nodejs \
      reattach-to-user-namespace \
      ruby \
      shellcheck \
      tmux \
      urlview \
      vim \
      wget \
      yarn \
      zsh

    # Casks
    brew cask install \
      applepi-baker \
      atom \
      authy \
      cleanmymac \
      cloudapp \
      coconutbattery \
      filezilla \
      firefox \
      flixtools \
      font-hack-nerd-font \
      google-chrome \
      itau \
      iterm2 \
      keka \
      lastpass \
      macvim \
      plex-media-server \
      robo-3t \
      silicon-labs-vcp-driver \
      sizeup \
      spotify \
      transmission \
      vlc \
      steam \
      wch-ch34x-usb-serial-driver \
      folx \
      virtualbox \
      virtualbox-extension-pack \
      vagrant \
      docker \
      --language=pt-BR

    # Atom packages
    apm install \
      sync-settings

    # Node.js packages
    sudo yarn global add \
      eslint \
      --ignore-optional

    #
    # App Store
    #
    # Amphetamine
    mas install 937984704
    # Valentina Studio
    mas install 604825918
    # Clean My Drive 2
    mas install 523620159

    ;;
  *)
    echo "Invalid system."
    exit 1

    ;;
esac

#
# Settings
#
# Delete old files
rm -rf ~/.dotfiles ~/.zshrc ~/.gitconfig ~/.vim ~/.vimrc ~/.gnupg ~/.ssh ~/.muttrc ~/.mutt ~/.mailcap ~/.tmux.conf ~/.tmux

# Clone dotfiles
git clone --recursive https://github.com/gufranco/dotfiles.git ~/.dotfiles --depth=1
cd ~/.dotfiles || exit 1
git remote set-url origin git@github.com:gufranco/dotfiles.git

# Zsh
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/themes/zsh/dracula.zsh-theme ~/.dotfiles/zsh/.oh-my-zsh/custom/themes/dracula.zsh-theme
echo "$(which zsh)" | sudo tee /etc/shells
sudo sed -i -- 's/auth       required   pam_shells.so/# auth       required   pam_shells.so/g' /etc/pam.d/chsh
sudo chsh $USER -s "$(which zsh)"

# Git
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig

# Vim
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc
vim +PlugUpgrade +PlugInstall +qall

# GPG
ln -s ~/.dotfiles/gnupg ~/.gnupg
if [[ "$(uname)" == "Linux" ]]; then
  echo "pinentry-program /usr/bin/pinentry-curses" > ~/.gnupg/gpg-agent.conf
elif [[ "$(uname)" == "Darwin" ]]; then
  echo "pinentry-program /usr/local/bin/pinentry-curses" > ~/.gnupg/gpg-agent.conf
fi
chmod 700 ~/.gnupg
chmod 400 ~/.gnupg/keys/*
gpg --import ~/.gnupg/keys/personal.public
gpg --import ~/.gnupg/keys/personal.private

# SSH
ln -s ~/.dotfiles/ssh ~/.ssh
chmod 400 ~/.ssh/id_rsa

# NeoMutt
ln -s ~/.dotfiles/mutt/.muttrc ~/.muttrc
ln -s ~/.dotfiles/mutt ~/.mutt
ln -s ~/.dotfiles/mutt/.mailcap ~/.mailcap

# Tmux
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux ~/.tmux
bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Tilix
if [[ "$(uname)" == "Linux" ]]; then
  mkdir -p ~/.config/tilix/schemes
  ln -s ~/.dotfiles/themes/Tilix/Dracula.json ~/.config/tilix/schemes/Dracula.json
fi
