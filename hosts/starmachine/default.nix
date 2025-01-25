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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # graphics card stuff
  hardware.opengl.enable = true;
  hardware.nvidia = {
    open = false;
  };

  # Enable sound with pipewire.
  sound.enable = false; # https://github.com/NixOS/nixpkgs/issues/319809#issuecomment-2167912680
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SECURITY --------------------------
  
  # security exceptions -------------
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
