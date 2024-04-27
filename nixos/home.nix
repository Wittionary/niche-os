{ config, pkgs, ... }:

{
  imports =
  [
    #./hardware-configuration.nix
    <home-manager/nixos>
  ];

# Global stuff
home-manager.useUserPackages = true;
home-manager.useGlobalPkgs = true;


# Let Home Manager install and manage itself. This is for standaloe install
# See: https://itsfoss.com/home-manager-nixos/#standalone-installation-of-home-manager
# programs.home-manager.enable = true;

  home-manager.users.witt = { pkgs, ... }: {
    home.packages = with pkgs; [ 
      # pkgs.neofetch
      # pkgs.podman
    ];

    home.stateVersion = "23.11"; # should stay at the version you originally installed.
  };
}