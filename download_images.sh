# ./download_images.sh http://exemple.com/api --> utiliser le script

#! /bin/bash

IFS=$'\n'

mkdir -p $(basename $1)
cd $(basename $1)

JSON=collection.json

echo "Retrieving collection items list"
curl -sl $1/items > $JSON
echo "$(jq .features[].properties.datetime $JSON | wc -l) pictures to download"
for P in $(jq .features[] $JSON -c)
do
  URL=$(echo $P | jq .assets.hd.href -r)
  TS=$(echo $P | jq .properties.datetime -r)
  curl -sl $URL > tmp.jpg
  mv tmp.jpg $TS.jpg
  echo -n '.'
done
echo ""
cd ..; mv $(basename $1) $(jq -r .features[0].properties.datetime $(basename $1)/$JSON)
echo 'Done'