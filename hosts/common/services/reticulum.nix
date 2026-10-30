# This module contains all the config needed to be a reticulum server
{
  ...
}:
{
  services.rnsd = {
    enable = true;
    # identityFile = "<path-to-rnsd-identity-file>";

    settings = {
      reticulum = {
        enable_transport = true;
        share_instance = true;
        instance_name = "default";
        shared_instance_type = "unix";
      };

      interfaces = {
        auto = {
          type = "AutoInterface";
          enabled = true;
        };
      };
      # openMulticastPorts = true;
      healthCheck.enable = true;
    };
  };

  services.lxmd = {
    enable = true;
    settings = {
      healthCheck = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
      29716 # Required for AutoInterface - https://reticulum.network/manual/interfaces.html#:~:text=it%20may%20block%20traffic%20required
      42671
    ];
  };
}
