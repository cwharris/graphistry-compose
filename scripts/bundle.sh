#!/bin/bash

echo -e "Bundling Graphistry for Distribution"

docker save -o containers.tar \
    spengler.grph.xyz/bundle/nginx-proxy:2001 \
    spengler.grph.xyz/bundle/graphistry-central:2001 \
    spengler.grph.xyz/bundle/graphistry-viz:2001 \
    spengler.grph.xyz/bundle/graphistry-pivot:2001 \
    spengler.grph.xyz/bundle/mongo:3.2.20

rm -rf dist && mkdir -p dist
touch dist/graphistry.tar.gz
tar -czf dist/graphistry.tar.gz docker-compose.yml scripts etc/nginx containers.tar .env README.md bootstrap


