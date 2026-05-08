#!/bin/bash

VERSION=1.0.1
url=https://github.com/igraph/igraph/releases/download/${VERSION}/igraph-${VERSION}.tar.gz
curl -L ${url} > sources.tar.gz

tar -xvf sources.tar.gz
rm -rf igraph
mv igraph-${VERSION} igraph

rm -rf igraph/tests 
rm -rf igraph/doc
rm -rf igraph/examples
