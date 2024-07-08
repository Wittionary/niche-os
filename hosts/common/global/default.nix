{ 
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {


 
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  programs.vim.defaultEditor = true;

  fonts.fonts = with pkgs; [
    ibm-plex
  ];
}