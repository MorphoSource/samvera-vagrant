#!/bin/sh

if [ ! -e $1/rdr ]; then
  echo "Provisioning RDR (Research Data Repository)"
  cd $1
  git clone https://github.com/duke-libraries/rdr.git
  cd rdr
  bundle install
  bin/rails db:setup
  bin/rails hyrax:workflow:load
  cp config/role_map.yml.sample config/role_map.yml
  bin/rails hydra:server &
  hydra_pid=$!
  echo "Waiting for TCP 127.0.0.1:3000 / 127.0.0.1:8984 from hydra:server PID ${hydra_pid}..."
  while ! nc -q 1 127.0.0.1 3000 </dev/null; do sleep 1; done
  while ! nc -q 1 127.0.0.1 8984 </dev/null; do sleep 1; done
  echo "RDR server available, creating default admin set"
  bin/rails hyrax:default_admin_set:create
  echo "Killing RDR PID $hydra_pid and child processes"
  pkill -INT -P $hydra_pid
  echo "RDR terminated (intentionally)"
else
  echo "RDR already provisioned, skipping"
fi
