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
    ./desktop.nix
    ./hardware.nix
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
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (callPackage ./sddm-themes.nix { }).sddm-theme-dialog # login screen theme
    where-is-my-sddm-theme

    # dev tools
    claude-agent-acp
    claude-code
    codex # OpenAI
    codex-acp
    dotnetCorePackages.sdk_10_0-bin
    git
    git-credential-manager
    jq
    nil # nix language server
    nixd # another nix language server
    ollama
    python3Minimal
    uv # python package and env management
    zola
    # see also `containers.nix`

    # general admin / utilities
    arcanechat-tui
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

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 60d --keep 10";
      flake = "/home/witt/git/niche-os"; # TODO: have this take in variables
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };

    zsh.enable = true;
  };

  services.ollama = {
    enable = true;
    port = 11434;
    openFirewall = false;
    package = pkgs.ollama-cuda;
    loadModels = [
      "dolphin3"
      "gemma3"
      "gemma3:27b"
      "deepseek-r1:latest"
      "deepseek-r1:1.5b"
    ];
  };

  # SECURITY --------------------------
  security.polkit.enable = true; # needed for sway
  security.pam.services.swaylock = { }; # needed for swaylock

  # security exceptions -------------
  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
  ];
}
