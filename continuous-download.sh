#!

# Set the path to the Git repository
repo_url="https://github.com/Wittionary/niche-os"

while true; do
    # Get the current time in HH:MM format
    current_time=$(date +"%H:%M")

    # Pull the Git repository
    REMOTE_STATUS=$(git pull "$repo_url")

    # Check if the repository has changed
    if [[ $REMOTE_STATUS == "Already up to date." ]]; then
        echo "$current_time - repo hasn't changed"
    else
        echo "$current_time - changes found"
	    #git pull "$repo_url"
        sudo nixos-rebuild switch &
        wait
        echo "$current_time - rebuild done"
    fi

    # Wait for 1 minute before checking again
    echo "$current_time - sleeping"
    sleep 1m
done

