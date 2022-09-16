#!/bin/sh
set -e

if [ ! -f /var/pocketbase/data.sqlite ]; then
	litestream restore -if-db-not-exists -if-replica-exists /var/pocketbase/data.db
fi

exec litestream replicate -exec "pocketbase --dir /var/pocketbase/ serve --http 0.0.0.0:8080"