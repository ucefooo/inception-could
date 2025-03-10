#!/bin/bash

# DATA_PATH="/Users/$(whoami)/Desktop/data/"
DATA_PATH="/home/data/"
WP_DATA_PATH="${DATA_PATH}wordpress/"
DB_DATA_PATH="${DATA_PATH}database/"

if [ ! -d ${DATA_PATH} ]; then
    mkdir -p ${WP_DATA_PATH}
    mkdir -p ${DB_DATA_PATH}
fi

chmod -R 777 ${DATA_PATH}*