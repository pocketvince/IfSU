#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 URL COMMAND INTERVAL"
    exit 1
fi
URL=$1
COMMAND=$2
INTERVAL=$3
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36"
# Check cloudflare
content=$(curl -s -A "$USER_AGENT" "$URL")
if echo "$content" | grep -q "cloudflare"; then
    echo "Cloudflare script detected, script will not work"
exit
else
    echo "Start"
fi
get_site_hash() {
    curl -s -A "$USER_AGENT" "$URL" | md5sum | awk '{print $1}'
}
echo "Checking dynamic content..."
INITIAL_HASH=$(get_site_hash)
sleep $INTERVAL
SECOND_HASH=$(get_site_hash)
#Doublec check ads
ad_keywords=("mdm.net" "googleadservices" "doubleclick.net" "adroll.com" "taboola.com" "outbrain.com" "adsrvr.org" "adnxs.com" "advertising.com" "criteo.com" "pubmatic.com" "rubiconproject.com" "openx.net" "serving-sys.com" "yieldmanager.com" "quantserve.com" "contextweb.com" "mediamath.com" "bidswitch.net" "simpli.fi" "spotx.tv" "sharethrough.com" "districtm.io" "lijit.com" "sonobi.com" "revcontent.com" "conversantmedia.com" "exponential.com" "zedo.com" "undertone.com" "moatads.com" "adform.com" "sovrn.com" "aolcloud.net" "teads.tv" "adtechus.com" "bluekai.com" "casalemedia.com" "yieldlab.net" "smartadserver.com" "adition.com" "advertising.amazon.com" "adcolony.com")
for keyword in "${ad_keywords[@]}"; do
    if echo "$content" | grep -q "$keyword"; then
echo "The site contains an advertising agency, need to switch to the dynamic version"
INITIAL_HASH=0
    fi
done
if [ "$INITIAL_HASH" != "$SECOND_HASH" ]; then
echo "$1 seems to have dynamic content."
echo "Curl result extraction"
curl -s -A "$USER_AGENT" "$URL" > tempo1.html
sleep $INTERVAL
curl -s -A "$USER_AGENT" "$URL" > tempo2.html
echo "Creation of a reference file monitoring start for updates"
diff -U 0 tempo1.html tempo2.html | grep -P '^\@\@' | awk '{print $3}' | sed 's/[^0-9,]//g' > tempo_dif.txt
while read -r line; do
sed -i "${line}d" "tempo2.html"
done < "tempo_dif.txt"
INITIAL_HASH=$(cat tempo2.html | md5sum | awk '{print $1}')
CURRENT_HASH=$(cat tempo2.html | md5sum | awk '{print $1}')
echo "Start monitoring for updates."
#loop
COUNT=0
while true; do
    if [ "$INITIAL_HASH" != "$CURRENT_HASH" ]; then
        echo "Update detected: Run command..."
        rm tempo1.html tempo2.html tempo3.html tempo_dif.txt
        eval "$COMMAND"
        break
    else
        COUNT=$((COUNT+1))
        date=$(date)
        echo "$date - n°$COUNT - No update detected."
        sleep "$INTERVAL"
        curl -s -A "$USER_AGENT" "$URL" > tempo3.html
        while read -r line; do
        sed -i "${line}d" "tempo3.html"
        done < "tempo_dif.txt"
        CURRENT_HASH=$(cat tempo3.html | md5sum | awk '{print $1}')
fi
done
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
        date=$(date)
        echo "$date - n°$COUNT - No update detected."
        sleep "$INTERVAL"
    fi
done
