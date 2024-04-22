#!
# Points the system directory over to the git-managed configurations

NIXOS_DIR="/etc/nixos/"
GIT_DIR="/home/witt/git/niche-os/nixos/"
CONFIGS="configuration.nix home-manager.nix"

for config in $CONFIGS; do
	FILEPATH="$NIXOS_DIR$config"
	
	# is present but not as a symlink
    if [[ -f "$FILEPATH" && ! ( -L "$FILEPATH" ) ]]; then
        cp -v "$FILEPATH" "$FILEPATH.backup"

	# is a symlink
    elif [[ -L "$FILEPATH" ]]; then
        echo "$FILEPATH is already symlinked"
    else
        ln --symbolic --verbose "$GIT_DIR$config" "$FILEPATH" && echo "$FILEPATH is now a symlink"
    fi
done
