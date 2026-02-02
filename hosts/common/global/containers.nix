{ config, pkgs, ... }:

{
  # Enable Podman
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other
    defaultNetwork.settings.dns_enabled = true;

    # Periodically prune old images, containers, volumes
    autoPrune = {
      enable = true;
      dates = "monthly";
    };
  };

  # Install packages
  environment.systemPackages = with pkgs; [
    podman
    podman-compose
  ];

  # Enable container networking
  # This is important for rootless containers to work properly
  virtualisation.containers = {
    enable = true;

    # Storage settings
    storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "$HOME/.local/share/containers/storage";

        options.overlay = {
          mountopt = "nodev,metacopy=on";
        };
      };
    };

    registries.search = [
      "quay.io"
    ];
  };

  # This allows non-root users to run containers
  users.users.witt = {
    extraGroups = [ "podman" ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };

  # Optional: Enable systemd socket activation for Podman API
  # Useful if you want to use tools that communicate with Podman via API
  # systemd.sockets.podman = {
  #   enable = true;
  #   wantedBy = [ "sockets.target" ];
  #   socketConfig = {
  #     ListenStream = "/run/podman/podman.sock";
  #   };
  # };
}
