{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    ./audio.nix
    ./containers.nix
    ./networking.nix
    # ./sddm-themes.nix
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

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
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
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    witt = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      description = "witt";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      ignoreShellProgramCheck = true; # because home.nix is managing shell
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalization properties.
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

    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
  };

  services = {
    desktopManager.gnome.enable = true;
    #displayManager.setupCommands = "sway"; # is this how I start sway?
  };

  services.displayManager = {
    defaultSession = "gnome"; # gnome
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm; # https://github.com/NixOS/nixpkgs/issues/292761#issuecomment-2110094381
      #extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
      theme = "sddm-theme-dialog"; # "where-is-my-sddm-theme";
      wayland.enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # support Thunderbolt devices
  services.hardware.bolt.enable = true;

  # hardware acceleration
  hardware.graphics.extraPackages = [
    pkgs.intel-compute-runtime
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (callPackage ./sddm-themes.nix { }).sddm-theme-dialog # login screen theme
    where-is-my-sddm-theme

    # dev tools
    dotnetCorePackages.sdk_10_0-bin
    git
    git-credential-manager
    jq
    nil # nix language server
    nixd # another nix language server
    python3Minimal
    uv # python package and env management
    zola
    # see also `containers.nix`

    # general admin / utilities
    arcanechat-tui
    bottles # wine / exe wrapper
    curl
    deltachat-desktop
    file
    fluffychat
    netbird-ui # network my devices together
    nh # nix helper CLI - https://github.com/viperML/nh
    mumble # client
    nmap
    stoat-desktop
    openssl

    # privacy / anonymity-based
    i2p # https://geti2p.net/en/about/intro
    mullvad # CLI tool for the VPN client
    simplex-chat-desktop
    tor-browser
    tutanota-desktop

    # system

    # terminal
    cowsay
    figlet
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
    wlr = {
      # sway
      enable = true;
    };
  };

  # SECURITY --------------------------
  security.polkit.enable = true; # needed for sway
  security.pam.services.swaylock = { }; # needed for swaylock

  # security exceptions -------------
  nixpkgs.config.permittedInsecurePackages = [ ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  fonts.packages = with pkgs; [
    ibm-plex
  ];
}
