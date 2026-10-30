{
  pkgs,
  lib,
  outputs,
  config,
  ...
}: let
  hosts = lib.attrNames outputs.nixosConfigurations;
in {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/features/deploy.nix
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


  services.prometheus = {
    enable = true;
    globalConfig = {
      # Scrape a bit more frequently
      scrape_interval = "30s";
    };
    scrapeConfigs = [
      {
        job_name = "hosts";
        scheme = "http";
        static_configs =
          map (hostname: {
            targets = [
              "${hostname}:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels.instance = hostname;
          })
          hosts;
      }
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      9090 # prometheus server
    ];
  };

  # keep prometheus metrics around after.. reboot?
  # Source: https://github.com/Misterio77/Foundry/blob/b9cc07e5adaac816812ef5320069c89122c63ac8/hosts/nixos/alcyone/services/prometheus.nix#L95
  # environment.persistence = {
  #     "/persist".directories = [
  #       {
  #         directory = "/var/lib/prometheus2";
  #         user = "prometheus";
  #         group = "prometheus";
  #         mode = "0700";
  #       }
  #     ];
  #   };

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
