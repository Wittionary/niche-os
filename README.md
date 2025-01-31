# niche-os
My nix OS configurations

## stuff you should know
- This uses flakes
- This is unstable - by nature of it using the unstable `nixpkgs` and `home-manager`

## getting started
Assumes the state of a freshly installed nixOS; nothing with an existing customized configuration.

On nixOS:
```bash
HOSTNAME=$(hostname)
mkdir $HOME/git/ && cd $HOME/git/
nix shell nixpkgs#git --extra-experimental-features nix-command --extra-experimental-features flakes
git clone https://github.com/Wittionary/niche-os.git --extra-experimental-features nix-command --extra-experimental-features flakes
cd $HOME/git/niche-os/

# set symlink so we use the version controlled config
sudo ln --symbolic --verbose /home/nixos/git/niche-os/ /etc/nixos
# TODO:
# - copy the hardware-configuration.nix
# - create new directories for $HOSTNAME
# - create default/empty configs for $HOSTNAME
# - get latest branch or create new one for $HOSTNAME

# build nixOS config
sudo nixos-rebuild switch --flake .#$HOSTNAME

# build home-manager config
# NOTE: after nixos-rebuild succeeds, it installs nh, but not home-manager - because home-manager CLI isn't available until the home-manager config is already ran
nh home switch .
```


On nixOS on WSL:
```bash
HOSTNAME="stormtrooper"
mkdir $HOME/git/ && cd $HOME/git/
nix shell nixpkgs#git --extra-experimental-features nix-command --extra-experimental-features flakes
git clone https://github.com/Wittionary/niche-os.git --extra-experimental-features nix-command --extra-experimental-features flakes
cd $HOME/git/niche-os/
# delete nixos directory - there's no hardware-configuration.nix to worry about for WSL
sudo rm -drf /etc/nixos/
# set symlink so we use the version controlled config
sudo ln --symbolic --verbose /home/nixos/git/niche-os/ /etc/nixos

# build nixOS config
sudo nixos-rebuild switch --flake .#$HOSTNAME

# build home-manager config
# NOTE: after nixos-rebuild succeeds, it installs nh, but not home-manager - because home-manager CLI isn't available until the home-manager config is already ran
nh home switch .
```

## general commands
After the initial setup, use `nh` for iteration
```bash
# for nix OS, system changes
nh os switch .

# for home-manager changes
nh home switch .

# every once in a while
nh clean all
```

## update flakes
Make sure you're on a new branch and that you've got 15 minutes for this thing to build.
```bash
nix flake update
nh os switch && nh home switch
```
After that, you'll probably get a handful of errors and warnings that need to be resolved as a result of new deprecations or naming changes.
