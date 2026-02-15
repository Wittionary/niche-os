{ pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # support Thunderbolt devices
  services.hardware.bolt.enable = true;

  # hardware acceleration
  hardware.graphics.extraPackages = [
    pkgs.intel-compute-runtime
  ];
}
