#!/bin/sh
set -e

./fider migrate

./fider &
PID=$!
until $(curl --silent --head --fail http://0.0.0.0:3000/); do
    sleep 1
done

curl --silent -X POST http://localhost:3000/_api/tenants \
  -H 'Content-Type: application/json' \
  -d "{\"legalAgreement\":false,\"tenantName\":\"Feedback\",\"subdomain\":\"\",\"name\":\"User\",\"email\":\"$USER_EMAIL\"}"

kill $PID

exec ./fider