#!/bin/sh
set -e

./fider migrate

./fider &
PID=$!

curl --head -X GET --retry 5 --retry-connrefused --retry-delay 1 --fail http://0.0.0.0:3000/

curl --silent -X POST http://localhost:3000/_api/tenants \
  -H 'Content-Type: application/json' \
  -d "{\"legalAgreement\":false,\"tenantName\":\"Feedback\",\"subdomain\":\"\",\"name\":\"User\",\"email\":\"$USER_EMAIL\"}"

kill $PID

exec ./fider