#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
set -euo pipefail
IFS=$'\n\t'

echo "Listening on PORT=$PORT..."

RESP="HTTP/1.1 200 OK
Content-Length: 13
Content-Type: text/plain

Hello, World!"

while true; do
    echo -e "$RESP" | nc -l "$PORT"
done
