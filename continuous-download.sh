#!

# Set the path to the Git repository
repo_url="https://github.com/Wittionary/niche-os"

while true; do
    # Get the current time in HH:MM format
    current_time=$(date +"%H:%M")

    # Pull the Git repository
#    git pull "$repo_url" 

    # Check if the repository has changed
    if [[ $(git pull "$repo_url") == "Already up to date." ]]; then
        echo "$current_time - repo hasn't changed"
    else
        echo "$current_time - changes found"
	git pull "$repo_url"
        sudo nixos-rebuild switch
    fi

    # Wait for 1 minute before checking again
    sleep 1m
done

