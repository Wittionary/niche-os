#!/bin/sh
# Points the system directory over to the git-managed configurations
# TODO: Update this to support new directory setup (with flakes) 

MY_HOME="/home/witt"
NIXOS_DIR="/etc/nixos/"
HOME_MANAGER_DIR="$MY_HOME/.config/home-manager/"
GIT_DIR="$MY_HOME/git/niche-os/nixos/"

CONFIGS="configuration.nix home.nix flake.nix"

for config in $CONFIGS; do
	FILEPATH="$NIXOS_DIR$config"
	
	# is present but not as a symlink
    if [[ -f "$FILEPATH" && ! ( -L "$FILEPATH" ) ]]; then
        mv -v "$FILEPATH" "$FILEPATH.backup"
        ln --symbolic --verbose "$GIT_DIR$config" "$FILEPATH" && echo "$FILEPATH is now a symlink"

	# is a symlink
    elif [[ -L "$FILEPATH" ]]; then
        echo "$FILEPATH is already symlinked"
    else
        ln --symbolic --verbose "$GIT_DIR$config" "$FILEPATH" && echo "$FILEPATH is now a symlink"
    fi
done
