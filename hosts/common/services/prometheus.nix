# This module contains all the config needed to be a prometheus server
{
  config,
  lib,
  outputs,
  ...
}:
let
  hosts = lib.attrNames outputs.nixosConfigurations;
in
{
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
      9090
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
}
