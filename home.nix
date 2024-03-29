{ pkgs, lib, config, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

  # Import generated file definitions
  generatedFiles = import ./generated-files.nix;

  p10kTheme = dotfiles/.p10k.zsh;

in {

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Enable fontconfig for font management
  fonts.fontconfig.enable = true;

  # Specify packages to be installed for the user
  home.packages = with pkgs; [
    fontconfig
    tflint
    hadolint

    #fonts
    cantarell-fonts
    fira-mono
    font-awesome
    material-design-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    terminus-nerdfont
    (nerdfonts.override {
      fonts =
        [ "FiraCode" "FiraMono" "Hack" "DroidSansMono" "Meslo" "RobotoMono" ];
    })
  ];

  # ZSH shell configuration
  programs.zsh = {
    initExtra = ''
      [[ ! -f ${p10kTheme} ]] || source ${p10kTheme}
    '';
    enable = true; # Enable ZSH as the shell
    enableAutosuggestions = true;

    # Set aliases for ZSH shell
    shellAliases = {
      # General aliases
      ll = "ls -l";
      la = "ls -a";

      # Git aliases
      g = "git";
      ga = "git add";
      gc = "git commit";
      gd = "git diff";
      gp = "git push";
      gs = "git status";

      # Flake build alias
      build =
        "sudo nixos-rebuild switch --flake ~/Git/nixos-build-2/#mySystem && home-manager switch --flake ~/Git/nixos-build/#myUser";
      update = "sudo nix flake update && build";
      clean =
        "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && build";
    };

    plugins = with pkgs; [{
      file = "powerlevel10k.zsh-theme";
      name = "powerlevel10k";
      src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
    }];
  };


  home = {
    username = userConfig.username;
    homeDirectory = userConfig.homeDirectory;
    stateVersion = "23.05";

    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
    };

    file = {
      ".config/rofi/config.rasi".source = ./dotfiles/.config/rofi/config.rasi;
      ".config/rofi/Arc-Dark.rasi".source = ./dotfiles/.config/rofi/Arc-Dark.rasi;
      ".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;
      ".config/waybar/config".source = ./dotfiles/.config/waybar/config;
      ".config/sway/config".source = ./dotfiles/.config/sway/config;
      ".config/alacritty/alacritty.yml".source = ./dotfiles/.config/alacritty/alacritty.yml;
      ".config/swappy/config".source = ./dotfiles/.config/swappy/config;
    };
  };
}



