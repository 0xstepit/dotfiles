# Dotfiles Configuration Repository

This repository contains my personalized configuration files for various command-line tools and applications. These dotfiles are tailored to enhance the functionality and aesthetics of the following components:

**zsh**: A powerful and customizable shell with features for improved productivity and user experience.

**alacritty**: A fast, cross-platform, and GPU-accelerated terminal emulator that prioritizes simplicity and performance.

**tmux**: A terminal multiplexer that enables the creation and management of multiple terminal sessions within a single window.

**nvim**: NeoVim, an extensible text editor that aims to improve upon the traditional Vim editor with modern features and plugins.

**yabai**: A tiling window manager for macOS that allows efficient window management through keyboard shortcuts and customizable layouts.

## Usage

To make use of these configurations, follow these steps

### Prerequisites

- [`stow`](https://www.gnu.org/software/stow/) to manage symlink.

### Setting

Clone the repository in `$HOME`:

```sh
git clone https://github.com/0xstepit/dotfiles.git ~/dotfiles
```

Create the required symlinks:

```sh
cd dotfiles
stow .
```

This configuration is made to handle all files in the `~/.config` folders which will be symlinked from the `dotfiles` one.

## Features

### zsh

To enable zsh syntax highlighting, run the following command:

```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git dotfiles/.config/zsh/plugins/zsh-syntax-highlighting
```

## Customization

Feel free to customize these configurations according to your preferences. Each directory contains a README file with specific information and customization options for that application.

## Acknowledgments

These dotfiles have been inspired by various sources in the open-source community. Special thanks to the developers and contributors of the tools and plugins used in this configuration.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
