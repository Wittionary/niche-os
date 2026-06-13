{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    desktopManager.xfce = {
      enable = true;
      enableWaylandSession = true;
    };

    # displayManager.lightdm = {
    #   enable = true;
    #   greeters = {
    #     # gtk.enable = true;
    #     slick = {
    #       enable = true;
    #       extraConfig = "";
    #     };
    #   };
    # };
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
  };

  # services = {
  #   desktopManager.gnome.enable = true;
  # };

  services.displayManager = {
    defaultSession = "xfce"; # gnome | sway
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm; # https://github.com/NixOS/nixpkgs/issues/292761#issuecomment-2110094381
      #extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
      theme = "sddm-theme-dialog"; # "where-is-my-sddm-theme";
      wayland.enable = false;
    };

  };

  environment.systemPackages = with pkgs; [
    # (callPackage ./sddm-themes.nix { }).sddm-theme-dialog # login screen theme
    # where-is-my-sddm-theme

    dbus
    # xfce4-alsa-plugin
    xfce4-session
    xfce4-appfinder
    xfce4-notifyd
    xfce4-exo
    xfce4-settings
    xfce4-terminal
    xfce4-taskmanager
    # xfce4-genmon-plugin
    xfce4-screenshooter
    xfce4-cpufreq-plugin
    xfce4-panel-profiles
    xfwm4-themes

    # thunar

    # ristretto
    # arc-theme
    # arc-icon-theme
  ];

  environment.sessionVariables = {
    XDG_CONFIG_DIRS = [
      "${pkgs.xfce4-session}/etc"
      "/run/current-system/sw/etc/xdg"
    ];
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  xdg.portal = {
    enable = true;
    # wlr = {
    #   # sway
    #   enable = true;
    # };
  };

  fonts.packages = with pkgs; [
    ibm-plex
  ];
}
