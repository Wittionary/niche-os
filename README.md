# niche-os
My nix OS configurations

Table of Contents
- [stuff you should know](#stuff-you-should-know)
- [getting started](#getting-started)
- [general commands](#general-commands)
- [update flakes](#update-flakes)

## stuff you should know
- This uses flakes
- This is unstable - by nature of it using the unstable `nixpkgs` and `home-manager`

## getting started
Assumes the state of a freshly installed nixOS; nothing with an existing customized configuration.

On nixOS:
```bash
# hostname is all lowers, hyphens ok
export HOSTNAME=$(hostname)
export TEMPLATE_HOST="snowmachine"

mkdir $HOME/git/ && cd $HOME/git/
nix shell nixpkgs#git --extra-experimental-features nix-command --extra-experimental-features flakes
git clone https://github.com/Wittionary/niche-os.git
cd $HOME/git/niche-os/

# TODO: get latest branch or create new one for $HOSTNAME
echo "NOTE: get latest branch or create new one for \'$HOSTNAME\'"

# setup hardware config
mkdir hosts/$HOSTNAME
sudo mv /etc/nixos/hardware-configuration.nix hosts/$HOSTNAME/hardware-configuration.nix
sudo mv /etc/nixos/configuration.nix ~ # back, back, back it up!
# setup home manager config
cp home/$TEMPLATE_HOST.nix home/$HOSTNAME.nix
sed -i "s/$TEMPLATE_HOST/$HOSTNAME/g" home/$HOSTNAME.nix
# create default config
cp hosts/$TEMPLATE_HOST/default.nix hosts/$HOSTNAME/default.nix
sed -i "s/$TEMPLATE_HOST/$HOSTNAME/g" hosts/$HOSTNAME/default.nix
# TODO: add config to flake.nix
echo "NOTE: add new entry to flake.nix"

# set symlink so we use the version controlled config
sudo rm -rfi /etc/nixos
sudo ln --symbolic --verbose /home/witt/git/niche-os/ /etc/nixos

# build nixOS config
sudo nixos-rebuild switch --flake .#$HOSTNAME

# build home-manager config
nh home switch .
```

NOTE: after `nixos-rebuild` succeeds, it installs `nh`, but not home-manager - because `home-manager` CLI isn't available until the home-manager config is already ran


## general commands
After the initial setup, use `nh` for iteration
```bash
# for nix OS, system changes
nh os switch .

# for home-manager changes
nh home switch .

# every once in a while unless you have it setup to run automatically
nh clean all
```

## update flakes
Make sure you're on a new branch and that you've got 15 minutes for this thing to download packages and build.
```bash
sudo nix flake update
nh os switch && nh home switch
```
After that, you'll probably get a handful of errors and warnings that need to be resolved as a result of deprecations or naming changes.
