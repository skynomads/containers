#!/bin/sh
set -e

litestream restore -if-db-not-exists -if-replica-exists /var/pocketbase/data.db

exec litestream replicate -exec "pocketbase --dir /var/pocketbase/ serve --http 0.0.0.0:8080"