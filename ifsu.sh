#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 URL COMMAND INTERVAL"
    exit 1
fi
URL=$1
COMMAND=$2
INTERVAL=$3
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36"
get_site_hash() {
    curl -s -A "$USER_AGENT" "$URL" | md5sum | awk '{print $1}'
}
echo "Checking dynamic content..."
INITIAL_HASH=$(get_site_hash)
sleep 5
SECOND_HASH=$(get_site_hash)
if [ "$INITIAL_HASH" != "$SECOND_HASH" ]; then
    echo "$1 seems to have dynamic content. Script stop."
    exit 1
fi

echo "Site is static: Start monitoring for updates."

#loop
COUNT=0
while true; do
    CURRENT_HASH=$(get_site_hash)
    if [ "$INITIAL_HASH" != "$CURRENT_HASH" ]; then
        echo "Update detected: Run command..."
        eval "$COMMAND"
        break
    else
        COUNT=$((COUNT+1))
        date=date
        echo "$date - n°$COUNT - No update detected."
        sleep "$INTERVAL"
    fi
done
