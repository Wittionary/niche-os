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
    ./hardware-configuration.nix

    ../common/global
  ];

  networking = {
    hostName = "hacktop";
  };
  services.resolved = {
    settings.Resolve = {
      Domains = [
        # TODO: consider implementing this native package; it's kind of trash though
        "45.90.28.0#${config.networking.hostName}-c49352.dns.nextdns.io"
        "2a07:a8c0::#${config.networking.hostName}-c49352.dns.nextdns.io"
        "45.90.30.0#${config.networking.hostName}-c49352.dns.nextdns.io"
        "2a07:a8c1::#${config.networking.hostName}-c49352.dns.nextdns.io"
      ];
    };
  };

  programs.ssh.extraConfig = "
  Host monolith
  User witt
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/monolith2
  ";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    playerctl # media controls
    swayosd # on-screen display of media key usage
  ];

  # SECURITY --------------------------

  # security exceptions -------------

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
