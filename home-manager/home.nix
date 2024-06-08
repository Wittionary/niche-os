# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports =
  [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = rec {
    username = "witt";
    homeDirectory = "/home/${username}";
  };

# Global stuff
#home-manager.useUserPackages = true;
#home-manager.useGlobalPkgs = true;
# Nicely reload system units when changing configs
systemd.user.startServices = "sd-switch";


# Let Home Manager install and manage itself. This is for standaloe install
# See: https://itsfoss.com/home-manager-nixos/#standalone-installation-of-home-manager
programs.home-manager = {
	enable = true;
};

  # home-manager.users.witt = { pkgs, ... }: {
  home.packages = with pkgs; [
    _1password-gui
    azure-cli
    awscli2
    bat # batcat

    discord
    #dmenu-rs # dmenu but extensible and in Rust - https://github.com/Shizcow/dmenu-rs

    firefox
    fzf
    
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

  # AESTHETICS --------------------------
  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

  gtk.iconTheme.package = pkgs.gnome.adwaita-icon-theme;
  gtk.iconTheme.name = "Adwaita"; 
  
  # theming engine
  qt.enable = true;
  qt.platformTheme.name = "gtk3";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

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
    package = pkgs.vscode; # pkgs.vscode || pkgs.vscodium

    userSettings = {
      "editor.fontSize" = 16;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "powershell.promptToUpdatePowerShell" = false;
      "window.zoomLevel" = 1;
    };
  };

  # WAYLAND --------------------------
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      #modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch terminal on start
        {command = terminal;}
      ];
    };
  };
  programs.swaylock = {
    enable = true;
    settings = {
      color = "808080";
      font-size = 48;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };

  # TERMINAL --------------------------
  programs.kitty = {
    enable = true;
    theme = "Novel"; #"Doom One";
    font = {
      size = 18;
      package = pkgs.dejavu_fonts;
      name = "DeJavu Sans";
    };
    shellIntegration.enableZshIntegration = true;
  };

  # ZSH --------------------------
  programs.zsh =  {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
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

    initExtra = ''
      # PS1 deciphered:
      # Start bolding text; yellow bg; name of logged in user; magenta bg; hostname
      # blue bg; display working directory unless it's 3 dirs deep in which case display the current dir and its parent
      # if in privileged shell then show the star emoji, else show nothing
      # if last command exited 0 (success) then show happy face, else show mad/poo face
      # End bolding text; reset fg and bg colors to default
      logged_in_user="%{$bg[yellow]%}%{$fg[black]%}%n"
      kube_context="%{$bg[yellow]%}%{$fg[black]%} $active_kube_context"

      hostname="%{$bg[magenta]%}%{$fg[white]%}%M"
      active_acct_display="%{$bg[magenta]%}%{$fg[white]%}☁️ $active_acct_az"

      working_dir="%{$bg[blue]%}%(4~|../%2~|%~)"
      priv_shell="%(!.✨.)"
      exit_code="%(?.😀.💩)"
      PS1="%B$kube_context$active_acct_display$working_dir$priv_shell$exit_code%b%{$reset_color%} "

      left_boundary="%{$fg[red]%}(%{$reset_color%}"
      time="%T"
      bg_jobs="%(1j., %j."")"
      right_boundary="%{$fg[red]%})%{$reset_color%}"
      RPS1="%K{$bg[black]%}$left_boundary$time$bg_jobs$right_boundary%k "


      # FUNCTIONS ---------------------------
      g() { # git aliases/chords
          if [[ "$1" == "s" || "$1" == "" ]]; then
              git status -sb
          elif [[ "$1" == "b" ]]; then
              git branch --list
          elif [[ "$1" == "p" ]]; then
              git pull
          elif [[ "$1" == "can" ]]; then
              # Commit all now
              git add .
              CommitMessage = "Commit All @ $(date +%m-%d-%y) $(date +%H:%M:%S)"
              git commit -am $CommitMessage
          elif [[ "$1" == "ca" ]]; then
              git add .
              git commit -am $2
          elif [[ "$1" == "cu" ]]; then
              # Undo that last commit
              #echo "StackOverflow link is in clipboard"
              echo "https://stackoverflow.com/questions/927358/how-do-i-undo-the-most-recent-local-commits-in-git"
          elif [[ "$1" == "pp" ]]; then
              git push --progress
          fi
      }
      kc() { # kubectl but as a rainbow
          kubectl $@ | lolcat --freq=0.3
      }

      fsearch() { # Fuzzy search w/ file contents preview
          fzf --preview='batcat --style=numbers --color=always --line-range :500 {}' --preview-window=up:80% --height 100% --layout=default
      }

      whereami() { # determine which cloud provider and kubernetes' contexts I'm under and display
          # AZ CLI
          if [[ -z $(history | grep --perl-regexp '^\s{1,2}\d{1,4}\s{2}az\s.*') ]]; then 
              # az command has not run recently 
              active_acct_az=""
          else 
              active_acct_az=$(az account show -o tsv --query name | cut -c 1-13)
          fi

          # KUBECTL
          if [[ -z $(history | grep --perl-regexp '^\s{1,2}\d{1,4}\s{2}(sudo\s)?(kubectl|kc){1}\s.*$') ]]; then 
              # kubectl (or alias) has not run recently 
              active_kube_context=""
          else 
              active_kube_context=$(kubectl config current-context)
          fi
          
          source ~/.zshrc
      }
    '';
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11"; # should stay at the version you originally installed.

}
