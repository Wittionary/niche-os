# This module contains all the config needed for a host to be deployable too using deploy-rs
{
  lib,
  ...
}:
{
  services.openssh.settings.PasswordAuthentication = lib.mkForce false;

  nix.settings.trusted-users = [ "witt" ];
  users = {
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6lCkUHMpo4FI5YE4WgOA5NXNgCvzBs7pYsfSy+i2Hu witt" # hacktop
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9mm2Az18TBDKNZU7zwtDRVkGUOWzOI5NWTJIKnzNFd witt" # redo
        ];
      };
      witt = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6lCkUHMpo4FI5YE4WgOA5NXNgCvzBs7pYsfSy+i2Hu witt" # hacktop
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9mm2Az18TBDKNZU7zwtDRVkGUOWzOI5NWTJIKnzNFd witt" # redo
        ];
      };
    };
  };

  # so the host doesn't need sudo interactively used to switch to the new profile
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

}
