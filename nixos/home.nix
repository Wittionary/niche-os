{ config, pkgs, ... }:

{
  imports =
  [
    <home-manager/nixos>
  ];

# Global stuff
home-manager.useUserPackages = true;
home-manager.useGlobalPkgs = true;


# Let Home Manager install and manage itself. This is for standaloe install
# See: https://itsfoss.com/home-manager-nixos/#standalone-installation-of-home-manager
# programs.home-manager.enable = true;

  home-manager.users.witt = { pkgs, ... }: {
    home.packages = with pkgs; [
      _1password-gui
      azure-cli
      awscli2
      bat # batcat
      
      dmenu-rs # dmenu but extensible and in Rust - https://github.com/Shizcow/dmenu-rs

      firefox
      fzf
      
      home-manager # cli
      
      kubectl
      lolcat
      
      neofetch
      obsidian # v1.4.16 package is out-of-date -> insecure
      podman

      terraform
      terragrunt
      todoist-electron
      
      vivaldi
      vscode
      #vscode-with-extensions      
    ];

    # ALIASES --------------------------
    home.shellAliases = {
      # ALIASES ---------------------------
      cls="clear";
      d="podman";
      kc="kubectl";
      ll="ls -l";
      tf="terraform";
      tg="terragrunt";
      
      "aws.whoami"="aws iam get-user --query User.Arn --output text";
      "az.whoami"="az ad signed-in-user show --query userPrincipalName --output tsv";
      ".."="cd ..";
      "..."="cd ../..";
      "...."="cd ../../..";
    };
    
    # GIT --------------------------
    programs.git = {
      enable = true;
      delta = { # https://github.com/dandavison/delta
        enable = true;
        options = {
          side-by-side = true;
        };
      };
      userName = "Witt Allen";
      userEmail = "wittionary@users.noreply.github.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };
      };
    };
    
    # VS CODE --------------------------
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # generic
        mikestead.dotenv
        eamodio.gitlens
        ritwickdey.liveserver

        # dev ops stuff
        github.vscode-github-actions
        ms-kubernetes-tools.vscode-kubernetes-tools
        _4ops.terraform

        # frontend / CSS
        bradlc.vscode-tailwindcss

        # golang  
        golang.go

        # nix
        bbenoist.nix
        jnoortheen.nix-ide

        # powershell
        ms-vscode.powershell
        
        # python
        ms-python.vscode-pylance
        ms-python.python
        #ms-python.debugpy # extension not found? "attribute 'debugpy' missing"
      ];
      package = pkgs.vscodium; # pkgs.vscode

      userSettings = {
        "editor.fontSize" = 16;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "powershell.promptToUpdatePowerShell" = false;
        "window.zoomLevel" = 1;
      };
    };

    # ZSH --------------------------
    programs.zsh =  {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      history = {
        expireDuplicatesFirst = true; # space savers and clarity makers
        extended = true; # makes the format of the history entry more complicated: "history -fdD" vs "history"
        ignoreDups = true; # space savers and clarity makers
        path = "$HOME/.cache/zsh/history";
        size = 1001;
      };
      sessionVariables = {
        # non-prompt stuff
        FZF_DEFAULT_OPTS="--height 25% --layout=reverse";
      };
      syntaxHighlighting.enable = true;

      #promptInit = ''
      #''
    };
    programs.autojump = {
      enable = true;
      enableZshIntegration = true;
    };

    home.stateVersion = "23.11"; # should stay at the version you originally installed.
  };
}