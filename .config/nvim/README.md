# Neovim Configuration

This repository contains my personal Neovim configuration, aimed at improving the editing 
experience with various plugins, mappings, and settings. It utilizes lazy.nvim
plugin management and a curated set of plugins for enhanced functionality. I hope this
configuration will help you in making the coding experience blazingly fast! 🚀

## Installation

### Prerequisites

Make sure you have Neovim installed on your system. If you haven't installed Neovim yet, you can 
follow the instructions provided on the [official Neovim website](https://neovim.io/).

### Setup

1. Clone this repository to your Neovim configuration directory.

    ```bash
    git clone https://github.com/0xstepit/nvim.git ~/.config/nvim
    ```

2. Launch Neovim.

    ```bash
    nvim .
    ```

## Plugins Included

This configuration includes several plugins to enhance Neovim's capabilities. Plugins are contained
in the folder `lua/stepit/plugins`. The current configuration includes:

- LSP

- Support for working with Git

- Multidimensional history.

- Fuzzy finding.

- Formatting.

- An amazing colorscheme.

- Autocompletion.

- Harpoon to mark and navigate only principal files.

No useless tabs or overwhelming information, just a minimal configuration to allows you to focus
on coding.

## Key Mappings

Some key mappings have been defined to streamline various functionalities. You can find these 
mappings in the `lua/stepit/remap.lua` file along with comments to explain their purposes.

## Options and Customizations

Certain options and custom configurations have been set to optimize the Neovim environment. 
These configurations can be found in the `lua/stepit/options.lua` file with comments explaining 
their significance.

## Contributions

Feel free to fork this repository and customize it according to your preferences. If you encounter 
any issues or have suggestions for improvements, please create an issue or pull request.
