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

  environment.systemPackages = [
    pkgs.openssh-askpass
  ];
  programs.ssh.askPassword = "${pkgs.openssh-askpass}/libexec/x11-ssh-askpass";

  services.openssh.settings.PasswordAuthentication = lib.mkForce false;
  nix.settings.trusted-users = [ "witt" ];
  users = {
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6lCkUHMpo4FI5YE4WgOA5NXNgCvzBs7pYsfSy+i2Hu witt" # hacktop
        ];
      };
      witt = {
        openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6lCkUHMpo4FI5YE4WgOA5NXNgCvzBs7pYsfSy+i2Hu witt" # hacktop
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
