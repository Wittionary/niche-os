#!
# Points the system directory over to the git-managed configurations

NIXOS_DIR="/etc/nixos/"
HOME_MANAGER_DIR="$HOME/.config/home-manager/"
GIT_DIR="$HOME/git/niche-os/nixos/"

CONFIGS="configuration.nix home.nix"

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
