#!/bin/sh
# file : /scripts/cdjava
#
cd docker
find . -name "._*" -type f -delete && docker-compose up -d nginx mysql phpmyadmin