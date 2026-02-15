{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
  };

  services = {
    desktopManager.gnome.enable = true;
    #displayManager.setupCommands = "sway"; # is this how I start sway?
  };

  services.displayManager = {
    defaultSession = "gnome"; # gnome
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm; # https://github.com/NixOS/nixpkgs/issues/292761#issuecomment-2110094381
      #extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
      theme = "sddm-theme-dialog"; # "where-is-my-sddm-theme";
      wayland.enable = true;
    };
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  xdg.portal = {
    enable = true;
    wlr = {
      # sway
      enable = true;
    };
  };

  fonts.packages = with pkgs; [
    ibm-plex
  ];
}
