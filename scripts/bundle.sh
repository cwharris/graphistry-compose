#!/bin/bash

echo -e "Bundling Graphistry for Distribution"

docker save -o containers.tar \
    spengler.grph.xyz/release/nginx-proxy:2000 \
    spengler.grph.xyz/release/graphistry-central:2000 \
    spengler.grph.xyz/release/graphistry-viz:2000 \
    spengler.grph.xyz/release/graphistry-pivot:2000 \
    graphistry/mongo:3.2.20

mkdir dist
touch dist/graphistry.tar.gz
tar -czf dist/graphistry.tar.gz docker-compose.yml scripts etc containers.tar


