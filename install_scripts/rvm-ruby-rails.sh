#!/usr/bin/env bash

source /home/ubuntu/.rvm/scripts/rvm

#
# check for ruby 2.4.2
#
echo
echo 'check for ruby 2.4.2'
echo '--------------------'
ruby_version="$(rvm list 2>&1)"
if echo $ruby_version | grep -q 'ruby-2.4.2'; then
    echo 'ruby 2.4.2 already installed'
else
    echo 'installing ruby 2.4.2'
    rvm install 2.4.2
fi
echo

#
# check for rails 5.1.4
#
echo
echo 'check for Rails 5.1.4'
echo '---------------------'
rvm ruby-2.4.2 2>&1
rails_version="$(rails -v 2>&1)"
if echo $rails_version 2>&1 | grep -q 'Rails 5.1.4'; then
    echo 'rails Rails 5.1.4 already installed'
else
    echo 'installing Rails 5.1.4'
    gem install rails -v 5.1.4 --no-ri --no-rdoc
fi
echo

echo
echo 'installing bundler'
echo '------------------'
gem install bundler --no-ri --no-rdoc
echo
