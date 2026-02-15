{ lib, ... }:
{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    settings.Resolve = lib.mkDefault {
      Domains = [
        # TODO: consider implementing this native package; it's kind of trash though
        # TODO: refactor so the hostname is auto-prefixed in this global config
        "45.90.28.0#c49352.dns.nextdns.io"
        "2a07:a8c0::#c49352.dns.nextdns.io"
        "45.90.30.0#c49352.dns.nextdns.io"
        "2a07:a8c1::#c49352.dns.nextdns.io"
      ];
      DNSOverTLS = true;
      DNSSEC = false; # because NextDNS handles this
    };
  };

  networking.hosts = {
    # example: "0.0.0.0" = [ "site-to-block.net" ];
  };
  # networking.stevenBlackHosts = {
  #   enable = true;
  #   enableIPv6 = true;
  #   blockFakenews = false; # for performance
  #   blockGambling = true;
  #   blockPorn = true;
  #   blockSocial = false;
  # };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      5577 # spotify zeroconf
    ];
    allowedUDPPorts = [
      5353 # mDNS - required for spotify device discovery
    ];
  };
}
