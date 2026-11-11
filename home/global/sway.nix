{
  inputs,
  lib,
  config,
  ...
}:
{

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      # https://github.com/Alexays/Waybar/wiki/Configuration
      # https://github.com/Alexays/Waybar/blob/master/resources/config.jsonc
    };
    style = ''
      * {
         border: none;
         border-radius: 0;
         font-family: Source Code Pro;
       }
       window#waybar {
         background: #16191C;
         color: #AAB2BF;
       }
       #workspaces button {
         padding: 0 5px;
       }
    '';
  };

  # WAYLAND --------------------------
  wayland = {
    systemd.target = "sway-session.target";
    windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "kitty";
        startup = [
          # Launch terminal on start
          { command = terminal; }
        ];

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${config.wayland.windowManager.sway.config.menu}";
          "${modifier}+x" = "move workspace to output next"; # do not work :/
          "${modifier}+l" = "exec swaylock";
          "F1" = "workspace number 1";
          "F2" = "workspace number 2";
          "F3" = "workspace number 3";
          "F4" = "workspace number 4";
          "F5" = "workspace number 5";
          "F6" = "workspace number 6";
          "${modifier}+F1" = "move window to workspace number 1";
          "${modifier}+F2" = "move window to workspace number 2";
          "${modifier}+F3" = "move window to workspace number 3";
          "${modifier}+F4" = "move window to workspace number 4";
          "${modifier}+F5" = "move window to workspace number 5";
          "${modifier}+F6" = "move window to workspace number 6";

          # MEDIA CONTROLS FOR HACKTOP ---------- TODO: put it in hacktop.nix but merge with above config
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

        defaultWorkspace = "workspace number 1";
        bars = [
          {
            position = "top";
            # https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html#descrip
            fonts = {
              names = [
                "DejaVu Sans Mono"
                "Terminus"
              ];
              size = 16.0;
              style = "Bold Semi-Condensed";
            };
            # https://i3wm.org/docs/userguide.html#_colors
            colors = {
              background = "#0F2E2E";
            };
            statusCommand = "while date +'%A, %b %d %I:%M%P'; do sleep 5; done";
          }
        ];
        output = {
          "*" = {
            bg = "#236767 solid_color";
          };
        };
        gaps.inner = 10;
      };
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      # TODO: make un-ugly
      image = "file:///home/witt/git/niche-os/wallpapers/flowers-desaturated.jpg";
      scaling = "fit";
      color = "809ABB";
      # font = TODO;
      font-size = 24;
      indicator-idle-visible = false; # circle shows when not typing
      indicator-radius = 100;
      line-color = "ffffff";
      line-caps-lock-color = "ff0000";
      show-failed-attempts = true;
      ignore-empty-password = true;

      inside-color = "676767ff";
      inside-clear-color = "1f1f1f";
      inside-ver-color = "898f89";
      inside-wrong-color = "8f4656";

      separator-color = "ffffffff";

      text-color = "efefef";
      text-ver-color = "898f89";
      text-wrong-color = "8f4656";
    };
  };
  systemd.user.services.swaylock = {
    Unit.Description = "Lock screen";
    Service.ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
  };
}
