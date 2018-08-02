#!/bin/bash

echo -e "Bundling Graphistry for Distrobution"

docker save -o containers.tar \
    spengler.grph.xyz/release/nginx-proxy:2000 \
    spengler.grph.xyz/release/graphistry-central:2000 \
    spengler.grph.xyz/release/graphistry-viz:2000 \
    spengler.grph.xyz/release/graphistry-pivot:2000 \
    spengler.grph.xyz/release/mongo:3.2.20

rm -rf dist && mkdir -p dist
touch dist/graphistry.tar.gz
tar -czf dist/graphistry.tar.gz docker-compose.yml scripts etc containers.tar .env README.md


