{
  pkgs,
  ...
}:
{

  imports = [
    ./global # Gotta get the basics
    # ./features/games.nix
  ];

  programs.kitty = {
    themeFile = "Doom_One";
  };

  services.spotifyd = {
    settings = {
      # https://docs.spotifyd.rs/config/File.html#configuration-file
      global = {
        device_name = "starmachine"; # TODO: replace with variable
      };
    };
  };

  wayland = {
    windowManager.sway = {
      config = rec {
        output = {
          # output DP-3 resolution 2560x1440 position 0 0 background #236767 solid_color
          "GIGA-BYTE\ TECHNOLOGY\ CO\.\,\ LTD\.\ G27Q\ 22082B002607" = {
            resolution = "2560x1440";
            position = "0 0";
            #bg = "#236767 solid_color";
          };
          # output DP-4 resolution 2560x1440 position 2560 0 background #236767 solid_color
          "GIGA-BYTE\ TECHNOLOGY\ CO\.\,\ LTD\.\ G27Q\ 22082B002608" = {
            resolution = "2560x1440";
            position = "2560 0";
            #bg = "#236767 solid_color";
          };
        };
        gaps.inner = 10;
      };
    };
  };
}
