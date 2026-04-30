{ pkgs, ... }:
{
  # GAMING RELATED ------------------
  # resource: https://journix.dev/posts/gaming-on-nixos/
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    heroic # game launcher
    mangohud # simple overlay program for monitoring FPS, temperature, CPU and GPU load
  ];
}
