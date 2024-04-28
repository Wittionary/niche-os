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
      vscode-with-extensions      
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
#      config = {
#        
#      };
    };
    #programs.git-credential-oauth.enable = true; # requires rando to have access to my account
    

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