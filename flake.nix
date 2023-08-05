{
  description = "A flake for building Sway with custom configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    homeConfigurations = {
      myUser = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ({ pkgs, lib, ... }: {
            home.packages = with pkgs; [ sway waybar wob blueman github-cli neovim foot firefox ];

	   home.file.".config/sway/config".source = ./dotfiles/.config/sway/config;
	   home.file.".config/waybar/config".source = ./dotfiles/.config/waybar/config;
	   home.file.".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;
              
            home.sessionVariables = {
              WLR_NO_HARDWARE_CURSORS = "1";
              PATH = "${pkgs.sway}/bin:${pkgs.waybar}/bin:${pkgs.wob}/bin:${pkgs.blueman}/bin:${pkgs.github-cli}/bin:${pkgs.neovim}/bin:${pkgs.foot}/bin:${pkgs.firefox}/bin:$PATH";
            };

            programs.bash = {
              enable = true;
              shellAliases = {
                ll = "ls -l";
		vim = "nvim";
              };
            };

            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
            home.stateVersion = "22.05";
          })
        ];
      };
    };
  };
}
