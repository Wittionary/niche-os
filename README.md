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
# delete nixos directory - there's no hardware-configuration.nix to worry about
sudo rm /etc/nixos/
# set symlink
sudo ln --symbolic --verbose /home/wittnix/git/niche-os/ /etc/nixos
# build nixOS config
sudo nixos-rebuild switch --flake .#stormtrooper # prev: nixos
# build home-manager config
home-manager switch --flake .#witt@stormtrooper

```