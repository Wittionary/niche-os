{...}:{
  # settings for things that are container hosted and not defined in nix
  networking.firewall = {
    allowedTCPPorts = [
      3100 # grafana
    ];
  };
}
