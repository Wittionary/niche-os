{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    # desktopManager.xfce = {
    #   enable = true;
    #   # enableWaylandSession = true;
    # };

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
    # Configure keymap
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.qtgreet}/bin/qtgreet";
      };
    };
  };

  # services.displayManager = {
  #   defaultSession = "xfce"; # gnome | sway
  #   lightdm.enable = true;
  #   # sddm = {
  #   #   enable = true;
  #   #   package = pkgs.kdePackages.sddm; # https://github.com/NixOS/nixpkgs/issues/292761#issuecomment-2110094381
  #   #   #extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
  #   #   theme = "sddm-theme-dialog"; # "where-is-my-sddm-theme";
  #   #   wayland.enable = true;
  #   # };

  # };

  environment.systemPackages = with pkgs; [
    # (callPackage ./sddm-themes.nix { }).sddm-theme-dialog # login screen theme
    # where-is-my-sddm-theme

    dbus
    qtgreet
    qt6.qtwayland
  ];

  # environment.sessionVariables = {
  #   XDG_CONFIG_DIRS = [
  #     "${pkgs.xfce4-session}/etc"
  #     "/run/current-system/sw/etc/xdg"
  #   ];
  # };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
      # https://man.sr.ht/~kennylevinsen/greetd/#how-to-set-xdg_session_typewayland
      extraSessionCommands = ''
        # Session
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway

        # Wayland stuff
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
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
