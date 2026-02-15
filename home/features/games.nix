{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protonup-ng # use `protonup` to add/update game compatibilities
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
