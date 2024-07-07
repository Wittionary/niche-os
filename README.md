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
nix shell nixpkgs#git --extra-experimental-features nix-command --extra-experimental-features flakes
git clone https://github.com/Wittionary/niche-os.git --extra-experimental-features nix-command --extra-experimental-features flakes
cd niche-os/
# delete nixos directory - there's no hardware-configuration.nix to worry about
sudo rm -drf /etc/nixos/
# set symlink
sudo ln --symbolic --verbose /home/nixos/git/niche-os/ /etc/nixos

# build nixOS config
sudo nixos-rebuild switch --flake .#stormtrooper

# build home-manager config?
home-manager switch --flake .#witt@stormtrooper

```

## general commands
After the initial setup, use `nh` for iteration
```bash
# for nix OS, system changes
nh os switch

# for home-manager changes
nh home switch
```