{ pkgs, ... }:

{

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
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
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ]; # copied from https://github.com/budimanjojo/nix-config/blob/595f3cb2d7d8c5705a2f3589219dd4123b184e0a/modules/modules/nixos/core/mySystem/windowManager/sway/default.nix#L74-L75
  };
}
