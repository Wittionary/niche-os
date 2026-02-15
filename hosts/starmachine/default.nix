{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    ./hardware-configuration.nix

    ../common/global
  ];

  networking = {
    hostName = "starmachine";
  };
  services.resolved = {
    settings.Resolve = {
      Domains = [
        # TODO: consider implementing this native package; it's kind of trash though
        "45.90.28.0#starmachine-c49352.dns.nextdns.io"
        "2a07:a8c0::#starmachine-c49352.dns.nextdns.io"
        "45.90.30.0#starmachine-c49352.dns.nextdns.io"
        "2a07:a8c1::#starmachine-c49352.dns.nextdns.io"
      ];
    };
  };

  # graphics card stuff
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = false;
    };
  };

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
