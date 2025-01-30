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
    hostName = "snowmachine";
  };
  services.resolved = {
    extraConfig = ''
      DNS=45.90.28.0#snowmachine-c49352.dns.nextdns.io # TODO: consider implementing this native package; it's kind of trash though
      DNS=2a07:a8c0::#snowmachine-c49352.dns.nextdns.io
      DNS=45.90.30.0#snowmachine-c49352.dns.nextdns.io
      DNS=2a07:a8c1::#snowmachine-c49352.dns.nextdns.io
    '';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver = {
    videoDrivers = [ "displayLink" "modesetting" ];
  };


  # SECURITY --------------------------

  # security exceptions -------------
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
