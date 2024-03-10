# Dotfiles Configuration Repository
This repository contains my personalized configuration files for various command-line tools and applications. These dotfiles are tailored to enhance the functionality and aesthetics of the following components:

**zsh**: A powerful and customizable shell with features for improved productivity and user experience.

**alacritty**: A fast, cross-platform, and GPU-accelerated terminal emulator that prioritizes simplicity and performance.

**tmux**: A terminal multiplexer that enables the creation and management of multiple terminal sessions within a single window.

**nvim**: NeoVim, an extensible text editor that aims to improve upon the traditional Vim editor with modern features and plugins.

**yabai**: A tiling window manager for macOS that allows efficient window management through keyboard shortcuts and customizable layouts.

**skhd**: Simple Hotkey Daemon for macOS, enabling customizable global hotkeys to control various aspects of the system and applications.

## Usage
To make use of these configurations, follow these steps:

Clone the Repository:

bash
```sh
git clone https://github.com/your-username/dotfiles.git ~/.config
cd ~/.config
```

This configuration is made to handle all files in the `~/.config` folder. The prerequisite for this, is to set this folder as the `XDG_CONFIG_HOME` in the `.zshenv` file:

```sh
touch ~/.zshenv
```

Then, add to it the following lines:

```sh
export DOTFILES="$HOME/.config/"
export XDG_CONFIG_HOME="$DOTFILES"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# Zsh configuration
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
```

## Customization
Feel free to customize these configurations according to your preferences. Each directory contains a README file with specific information and customization options for that application.

## Acknowledgments
These dotfiles have been inspired by various sources in the open-source community. Special thanks to the developers and contributors of the tools and plugins used in this configuration.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

