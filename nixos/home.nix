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
      _1password
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
      config = {
        init = {
          defaultBranch = "main";
        };
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };
      };
    };

    # ZSH --------------------------
    programs.zsh =  {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      history = {
        expireDuplicatesFirst = true; # space savers and clarity makers
        extended = true; # makes the format of the history entry more complicated: "history -fdD" vs "history"
        ignoreDups = true; # space savers and clarity makers
        path = "$HOME/.cache/zsh/history";
        size = 1001;
      };
      sessionVariables = {
        # PS1 deciphered:
        # Start bolding text; yellow bg; name of logged in user; magenta bg; hostname
        # blue bg; display working directory unless it's 3 dirs deep in which case display the current dir and its parent
        # if in privileged shell then show the star emoji, else show nothing
        # if last command exited 0 (success) then show happy face, else show mad/poo face
        # End bolding text; reset fg and bg colors to default
        logged_in_user="%{$bg[yellow]%}%{$fg[black]%}%n";
        kube_context="%{$bg[yellow]%}%{$fg[black]%} $active_kube_context";

        hostname="%{$bg[magenta]%}%{$fg[white]%}%M";
        active_acct_display="%{$bg[magenta]%}%{$fg[white]%}☁️ $active_acct_az";

        working_dir="%{$bg[blue]%}%(4~|../%2~|%~)";
        priv_shell="%(!.✨.)";
        exit_code="%(?.😀.💩)";
        PS1="%B$kube_context$active_acct_display$working_dir$priv_shell$exit_code%b%{$reset_color%} ";

        left_boundary="%{$fg[red]%}(%{$reset_color%}";
        time="%T";
        bg_jobs="%(1j., %j."")";
        right_boundary="%{$fg[red]%})%{$reset_color%}";
        RPS1="%K{$bg[black]%}$left_boundary$time$bg_jobs$right_boundary%k ";

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