{
  pkgs,
  ...
}:
{

  imports = [
    ./sway.nix
  ];

  services.xserver = {
    enable = true;

    # Configure keymap
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.displayManager.regreet = {
    enable = true;
    theme.name = "Adwaita";
    cursorTheme.name = "Adwaita";
    settings = {
      skip_selection = true;
      background.path = "/home/witt/git/niche-os/wallpapers/flowers-desaturated.jpg";
    };
  };

  environment.systemPackages = with pkgs; [
    regreet
  ];

  fonts.packages = with pkgs; [
    ibm-plex
  ];
}
