{
  description = "stepit Nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim pkgs.bat
        ];

      networking.computerName = "stepit's Macbook";
      networking.hostName = "spaceship";

      homebrew = {
        enable = true;
        brews = [ "gh" "cowsay" ];
        casks = [
          "google-chrome"

        ];
      };

      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      nix.linux-builder.enable = true;

      # Necessary for using flakes on this system.
      nix = {
        settings = {
          experimental-features = "nix-command flakes";
        };
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs = {
        # tmux ={
        #   enable = true;
        #   enableFzf = true;
        #   enableVim = true;
        #   enableMouse = true;
        #   # extraConfig 
        # };
        zsh = {
          enable = true;
          enableBashCompletion = true;
          enableCompletion = true;
          enableFzfCompletion = true;
          enableFzfHistory = true;
          enableSyntaxHighlighting = true;
        };
      };
      
      # Enable touch ID for sudo.
      security.pam.enableSudoTouchIdAuth = true;

      # Auto upgrade nix package and the daemon service.
      services = {
        # jankyborders = {
        #   enable = true;
        #   # active_color
        #   # inactive_color
        #   # width
        # };
        nix-daemon = {
          enable = true;
        };
        # sketchybar = {
        #   enable = true;
        # };
        # spacebar = {
        #   enable = true;
        #   package = pkgs.spacebar;
        #   config = {
        #       position                   = "top";
        #       display                    = "main";
        #       height                     = 30;
        #       title                      = "on";
        #       spaces                     = "on";
        #       clock                      = "on";
        #       power                      = "on";
        #       padding_left               = 20;
        #       padding_right              = 20;
        #       spacing_left               = 25;
        #       spacing_right              = 15;
        #       text_font                  = ''"BlexMono Nerd Font:Regular:12.0"'';
        #       icon_font                  = ''"Font Awesome 5 Free:Solid:12.0"'';
        #       background_color           = "0xff202020";
        #       foreground_color           = "0xffa8a8a8";
        #       power_icon_color           = "0xffcd950c";
        #       battery_icon_color         = "0xffd75f5f";
        #       dnd_icon_color             = "0xffa8a8a8";
        #       clock_icon_color           = "0xffa8a8a8";
        #       power_icon_strip           = " ";
        #       space_icon                 = "•";
        #       space_icon_strip           = "1 2 3 4 5 6 7 8 9 10";
        #       spaces_for_all_displays    = "on";
        #       display_separator          = "on";
        #       display_separator_icon     = "";
        #       space_icon_color           = "0xff458588";
        #       space_icon_color_secondary = "0xff78c4d4";
        #       space_icon_color_tertiary  = "0xfffff9b0";
        #       clock_icon                 = "";
        #       dnd_icon                   = "";
        #       clock_format               = ''"%d/%m/%y %R"'';
        #       right_shell                = "on";
        #       right_shell_icon           = "";
        #   };
        # };
      };
      # nix.package = pkgs.nix;


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.defaults = {
        dock.autohide = true;
        screencapture.location = "~/Pictures/Screenshots";
      };

      users.users = {
        stepit = {
          name = "stepit";
          home = "/Users/stepit";
          description = "Stefano Francesco Pitton";
        };
      };


      # Other interesting
      # environment.systemPath
      # environment.shellAliases
      # environment.variables
      # fonts.packages
      # direnv
      # ssh.knownHost

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#engine
    darwinConfigurations."spaceship" = nix-darwin.lib.darwinSystem {
      modules = [ 
      configuration 
      home-manager.darwinModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.stepit = import ./home.nix;
      }
      ];

    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."engine".pkgs;
  };
}
