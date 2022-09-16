#!/bin/sh
set -e

litestream restore -if-db-not-exists -if-replica-exists /var/pocketbase/data.db

exec litestream replicate -exec "/usr/local/bin/pocketbase --dir /var/pocketbase/ serve --http 0.0.0.0:8080"