# ./download_images.sh http://exemple.com/api --> utiliser le script
#! /bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <user_id>"
    exit 1
fi

USER_ID=$1
API_URL="https://panoramax.openstreetmap.fr/api/users/${USER_ID}/catalog/"

IFS=$'\n'

mkdir -p $(basename $1)
cd $(basename $1)

JSON=collection.json

echo "Retrieving collection items list"
curl -sL "${API_URL}" > ${JSON}

echo "$(jq .features[].properties.datetime "${JSON}" | wc -l) pictures to download"

for P in $(jq .features[] "${JSON}" -c); do
    URL=$(echo "${P}" | jq .assets.hd.href -r)
    TS=$(echo "${P}" | jq .properties.datetime -r)
    curl -sL "${URL}" > tmp.jpg
    mv tmp.jpg "${TS}.jpg"
    echo -n '.'
done

echo ""
cd .. ;
mv $(basename $1) $(jq -r .features[0].properties.datetime $(basename $1)/$JSON)
echo 'Done'
