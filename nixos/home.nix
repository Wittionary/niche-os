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


# Let Home Manager install and manage itself.
programs.home-manager.enable = true;

home-manager.users.witt = { pkgs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "witt";
  home.homeDirectory = "/home/witt";

  home.packages = [ 
    pkgs.neofetch
    pkgs.podman
  ];

  programs.bash.enable = true;



  home.stateVersion = "23.11"; # should stay at the version you originally installed.
};
}