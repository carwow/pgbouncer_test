#!/bin/bash

set -euo pipefail

APP="carwow-pgbouncer-test"
CPU_MS=500
DB_MS=500
RESULTS=$(mktemp -d -t pgbouncer-test-XXX)

function scale() {
  heroku ps:scale web=${1} --app ${APP}
  printf "grace period... "
  sleep 15
  printf "done.\n"
}

function pgbouncer() {
  heroku config:set PGBOUNCER_ENABLED=${1} --app ${APP}
  printf "grace period... "
  sleep 30
  printf "done.\n"
}

function finish() {
  echo "cleaning up..."
  heroku ps:scale web=0 --app ${APP}
  heroku config:set PGBOUNCER_ENABLED=false --app ${APP}
  echo "👋"
}

function trial() {
  local name=${1}
  local time=${2}
  local workers=${3}

  printf "Running ${name} for ${time} with ${workers} workers... "
  hey -c ${workers} -z ${time} -o csv "https://${APP}.herokuapp.com?cpu=${CPU_MS}&db=${DB_MS}&test_name=${name}" > "${RESULTS}/${name}-results.csv"
  printf "done. grace period... "
  sleep 30
  printf "done-done. \n"
}

echo "Testing against: ${APP}"
heroku login

echo "Start?"
read -n 1

trap finish EXIT

echo "Results will be stored in ${RESULTS}"

pgbouncer "false"

scale 1
trial "01-dyno-005" "45s" "5"
trial "01-dyno-010" "45s" "10"
trial "01-dyno-015" "45s" "15"
trial "01-dyno-020" "45s" "20"

scale 5
trial "05-dyno-030" "45s" "30"
trial "05-dyno-040" "45s" "40"
trial "05-dyno-050" "45s" "50"
trial "05-dyno-075" "45s" "75"

scale 10
trial "10-dyno-075" "45s" "75"
trial "10-dyno-100" "45s" "100"
trial "10-dyno-140" "45s" "140"

scale 15
trial "15-dyno-140" "45s" "140"
trial "15-dyno-250" "45s" "250"


scale 25
pgbouncer "false"
trial "25-dyno-250" "45s" "250"
trial "25-dyno-500" "45s" "500"

pgbouncer "true"
trial "25-dyno-250" "45s" "250"
trial "25-dyno-500" "45s" "500"

scale 50
pgbouncer "false"
trial "50-dyno-500" "45s" "500"
trial "50-dyno-750" "45s" "750"

pgbouncer "true"
trial "50-dyno-500" "45s" "500"
trial "50-dyno-750" "45s" "750"

scale 75
pgbouncer "false"
trial "75-dyno-750" "45s" "750"
trial "75-dyno-999" "45s" "999"

pgbouncer "true"
trial "75-dyno-750" "45s" "750"
trial "75-dyno-999" "45s" "999"
