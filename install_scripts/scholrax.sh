#!/bin/sh

if [ ! -e $1/scholrax ]; then
  echo "Provisioning Scholrax"
  cd $1
  git clone https://github.com/duke-libraries/scholrax.git
  cd scholrax
  bundle install
  bundle exec rake db:setup
  bundle exec rake hyrax:workflow:load
  cp config/role_map.yml.sample config/role_map.yml
  bundle exec rake hydra:server &
  hydra_pid=$!
  echo "Waiting for TCP 127.0.0.1:3000 / 127.0.0.1:8984 from hydra:server PID ${hydra_pid}..."
  while ! nc -q 1 127.0.0.1 3000 </dev/null; do sleep 1; done
  while ! nc -q 1 127.0.0.1 8984 </dev/null; do sleep 1; done
  echo "Scholrax server available, creating default admin set"
  bundle exec rake hyrax:default_admin_set:create
  echo "Killing Scholrax PID $hydra_pid and child processes"
  pkill -INT -P $hydra_pid
  echo "Scholrax terminated"
else
  echo "Scholrax already provisioned, skipping"
fi
