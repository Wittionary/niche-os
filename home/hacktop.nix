{
  pkgs,
  config,
  ...
}: {

  imports = [
    ./global # Gotta get the basics
  ];

  programs.kitty = {
    themeFile = "Doom_One";
  };

  services.swayosd = {
      enable = true;
      # OSD Margin from the top edge, 0.5 would be the screen center. May be from 0.0 - 1.0.
      topMargin = 0.9;
      #stylePath = "/etc/xdg/swayosd/style.css";
    };

  wayland.windowManager.sway = {
      enable = true;
      config = {

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in {
          "${modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${config.wayland.windowManager.sway.config.menu}";
          "${modifier}+l" = "exec swaylock";
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+Shift+1" = "move window to workspace number 1";
          "${modifier}+Shift+2" = "move window to workspace number 2";
          "${modifier}+Shift+3" = "move window to workspace number 3";
          "${modifier}+Shift+4" = "move window to workspace number 4";
          "${modifier}+Shift+5" = "move window to workspace number 5";
          "${modifier}+Shift+6" = "move window to workspace number 6";

          # Audio Volume Controls (Sink - Output)
          "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
          "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
          "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";

          # Microphone Volume Control (Source - Input)
          "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

          # Caps Lock
          "--release Caps_Lock" = "exec swayosd-client --caps-lock";

          # Brightness Controls
          "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
          "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";

          # Media Player Controls
          "XF86AudioPlay" = "exec swayosd-client --playerctl play-pause";
          "XF86AudioNext" = "exec swayosd-client --playerctl next";
          "XF86AudioPrev" = "exec swayosd-client --playerctl prev";

          # camera toggle
          # bluetooth/wifi toggle

        };


      };
    };
}
