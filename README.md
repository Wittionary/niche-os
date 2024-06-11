# niche-os
My nix OS configurations

## stuff you should know
- This uses flakes
- This is unstable - by nature of it using the unstable `nixpkgs` and `home-manager`

## getting started
Assumes a fresh state; nothing with an existing customized configuration.

On nixOS:

On nixOS on WSL:
```bash
cd $HOME
mkdir git
cd git/
nix run nixpkgs#git clone https://github.com/Wittionary/niche-os.git --extra-experimental-features nix-command --extra-experimental-features flakes
cd niche-os/
# backup default configuration
# set symlink
ln --symbolic --verbose . /etc/nixos/ # broken atm
# build nixOS config
sudo nixos-rebuild switch --flake .#WSL_ON_NIX_HOSTNAME_TBD
# build home-manager config
home-manager switch --flake .#witt@WSL_ON_NIX_HOSTNAME_TBD

```