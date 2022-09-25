#!/bin/sh
set -e

litestream restore -if-db-not-exists -if-replica-exists /var/pocketbase/data.db

if [ ! -f /var/pocketbase/data.db ]; then
  pocketbase --dir /var/pocketbase/ serve --http 0.0.0.0:8080 &
  PID=$!

  curl --head -X GET --retry 5 --retry-connrefused --retry-delay 1 --fail http://0.0.0.0:8080/_/

  curl --silent -X POST http://localhost:8080/api/admins \
    -H 'Content-Type: application/json' \
    -d "{\"email\":\"$POCKETBASE_EMAIL\",\"password\":\"$POCKETBASE_PASSWORD\",\"passwordConfirm\":\"$POCKETBASE_PASSWORD\"}"

  TOKEN=$(curl --silent -X POST http://localhost:8080/api/admins/auth-via-email \
    -H 'Content-Type: application/json' \
    -H "Accept: application/json" \
    -d "{\"email\":\"$POCKETBASE_EMAIL\",\"password\":\"$POCKETBASE_PASSWORD\"}" | jq -r '.token')

  echo "$TOKEN"

  curl -v -X PATCH http://localhost:8080/api/settings \
    -H 'Content-Type: application/json' \
    -H "Authorization: Admin $TOKEN" \
    -d "{\"meta\":{\"senderAddress\":\"$POCKETBASE_SENDER_ADDRESS\"},\"smtp\":{\"enabled\":true,\"host\":\"$POCKETBASE_SMTP_HOST\",\"port\":$POCKETBASE_SMTP_PORT,\"username\":\"$POCKETBASE_SMTP_USERNAME\",\"password\":\"$POCKETBASE_SMTP_PASSWORD\"},\"s3\":{\"enabled\":true,\"forcePathStyle\":true,\"region\":\"na\",\"bucket\":\"$POCKETBASE_S3_BUCKET\",\"endpoint\":\"$POCKETBASE_S3_ENDPOINT\",\"accessKey\":\"$POCKETBASE_S3_ACCESS_KEY\",\"secret\":\"$POCKETBASE_S3_SECRET\"}}"

  kill $PID
fi

exec litestream replicate -exec "pocketbase --dir /var/pocketbase/ serve --http 0.0.0.0:8080"