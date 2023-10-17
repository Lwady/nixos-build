{ config, pkgs, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

in {
  # Include hardware-specific configurations
  imports = [ ./hardware-configuration.nix ];

  # Boot settings related to systemd-boot and EFI
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Specify the Linux kernel package version
  };

  # OpenGL configuration settings
  hardware.opengl = {
    enable = true; # Enable OpenGL support
    driSupport = true; # Enable Direct Rendering Infrastructure support
  };

  # User configurations based on imported user-specific settings
  users.users.${userConfig.username} = {
    isNormalUser = true;
    home = userConfig.homeDirectory;
    shell = pkgs.zsh; # Setting Zsh as the default shell
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
  };

  # Programs Enable
  programs = {
    zsh.enable = true;
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  # Enable sound support
  sound.enable = true;

  # Hardware configuration for Sound/BT
  hardware = {
    pulseaudio.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true; # Power on Bluetooth devices at boot
    };
  };

  # Enable services
  services = {
    blueman.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    # Enable PipeWire
    pipewire.enable = true;
  };

  # Enable NetworkManager for network management
  networking.networkmanager.enable = true;

  # Enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Set timezone
  time.timeZone = "Europe/London";

  # List of packages to be globally installed on the system
  environment.systemPackages = with pkgs; [
    alacritty
    alsa-utils
    brightnessctl
    dconf
    direnv
    docker
    dunst
    firefox-wayland
    gh
    git
    github-cli
    gnome.gnome-boxes
    google-chrome
    grim
    home-manager
    python3Packages.pip
    rofi
    shfmt
    shellcheck
    slack
    slurp
    statix
    sway
    swaylock-effects
    swappy
    tidal-hifi
    unzip
    vscode
    waybar
    wdisplays
    wget
    wl-clipboard
    wob
    xfce.thunar
    yarn
    zsh
  ];

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable PAM for Swaylock
  security.pam.services.swaylock = { allowNullPassword = true; };

  # System version specification
  system.stateVersion = "23.05";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings.keep-outputs = true;
    settings.keep-derivations = true;
  };

  # Enable xdg desktop integration
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
