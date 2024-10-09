{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "stepit";
  home.homeDirectory = "/Users/stepit";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.git = {
  #   enable = true;
  #   userEmail = "joe@example.org";
  #   userName = "joe";
  # };
  # home.file = {
  #   # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  #   # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  #   # # symlink to the Nix store copy.
  #   # ".screenrc".source = dotfiles/screenrc;
  #
  #   # # You can also set the file content immediately.
  #   # ".gradle/gradle.properties".text = ''
  #   #   org.gradle.console=verbose
  #   #   org.gradle.daemon.idletimeout=3600000
  #   # '';
  #   ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
  #   ".config/skhd".source = ~/dotfiles/skhd;
  #   ".config/starship".source = ~/dotfiles/starship;
  # };
}
