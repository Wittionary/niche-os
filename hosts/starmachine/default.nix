{ 
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
    extraConfig = ''
      DNS=45.90.28.0#starmachine-c49352.dns.nextdns.io # TODO: consider implementing this native package; it's kind of trash though
      DNS=2a07:a8c0::#starmachine-c49352.dns.nextdns.io
      DNS=45.90.30.0#starmachine-c49352.dns.nextdns.io
      DNS=2a07:a8c1::#starmachine-c49352.dns.nextdns.io
    '';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # graphics card stuff
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
  };


  # SECURITY --------------------------
  
  # security exceptions -------------
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
