{
  pkgs,
  lib,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    ./hardware-configuration.nix

    ../common/global
    # ../common/global/gaming.nix
  ];

  networking = {
    hostName = "monolith";
  };
  services.resolved = {
    settings.Resolve = {
      Domains = [
        # TODO: consider implementing this native package; it's kind of trash though
        "45.90.28.0#monolith-c49352.dns.nextdns.io"
        "2a07:a8c0::#monolith-c49352.dns.nextdns.io"
        "45.90.30.0#monolith-c49352.dns.nextdns.io"
        "2a07:a8c1::#monolith-c49352.dns.nextdns.io"
      ];
    };
  };

  services.openssh.settings.PasswordAuthentication = lib.mkForce false;
  nix.settings.trusted-users = [ "witt" ];
  users = {
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6lCkUHMpo4FI5YE4WgOA5NXNgCvzBs7pYsfSy+i2Hu witt" # hacktop
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9mm2Az18TBDKNZU7zwtDRVkGUOWzOI5NWTJIKnzNFd witt" # redo
        ];
      };
      witt = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6lCkUHMpo4FI5YE4WgOA5NXNgCvzBs7pYsfSy+i2Hu witt" # hacktop
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9mm2Az18TBDKNZU7zwtDRVkGUOWzOI5NWTJIKnzNFd witt" # redo
        ];
      };
    };
  };
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  # graphics card stuff
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    # Uncomment this if swapping away from nouveau driver (req. for sway)
    # nvidia = {
    #   open = true;
    # };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
