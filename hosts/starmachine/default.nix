{ 
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    ./hardware-configuration.nix

    ../common/global
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      warn-dirty = false;
    };
    # Opinionated: disable channels
    channel.enable = true;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking = {
    hostName = "starmachine";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    witt = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      description = "witt";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      ignoreShellProgramCheck = true; # because home.nix is managing shell
      # user-specific packages are in home-manager
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    #displayManager.setupCommands = "sway"; # is this how I start sway?

    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
  };


  services.displayManager = {
    defaultSession = "gnome"; # gnome
    sddm = {
      enable = true;
      package = pkgs.lib.mkForce pkgs.libsForQt5.sddm; # https://github.com/NixOS/nixpkgs/issues/292761#issuecomment-2094854200
      extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
      theme = "sddm-theme-dialog"; #"where-is-my-sddm-theme";
      wayland.enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # support Thunderbolt devices
  services.hardware.bolt.enable = true;

  # hardware acceleration for starmachine
  hardware.opengl.extraPackages = [
    pkgs.intel-compute-runtime
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #_1password
    (callPackage ../common/global/sddm-themes.nix {}).sddm-theme-dialog # login screen theme
    where-is-my-sddm-theme

    #lightdm
    #lightdm-gtk-greeter

    # dev tools
    git
    git-credential-manager
    jq
    podman
    podman-compose
    python3Minimal
    uv # python package and env management

    # general admin / utilities
    curl
    file
    netbird-ui # network my devices together
    nh # nix helper CLI - https://github.com/viperML/nh
    nmap
    openssl

    # system
  
    # terminal
    tmux
    vim 
    wget
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 90d --keep 10";
    flake = "/home/witt/git/niche-os"; # TODO: have this take in variables
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  xdg.portal = {
    enable = true;
    wlr = { # sway
      enable = true;
    };
  };
  

  # SECURITY --------------------------
  security.polkit.enable = true; # needed for sway
  security.pam.services.swaylock = {}; # needed for swaylock

  # security exceptions -------------
  nixpkgs.config.permittedInsecurePackages = [
  "electron-25.9.0" # for obsidian 1.4.16
  ];
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
