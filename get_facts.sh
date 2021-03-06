#!/bin/bash

# Fix for squeeze, el7 and arch
export PATH=$PATH:/var/lib/gems/1.8/bin/:/usr/local/bin:/root/.gem/ruby/2.1.0/bin

# Install latest version of facter 
gem install bundler --no-ri --no-rdoc
bundle install --path vendor/bundler --without development test
operatingsystem=$(bundle exec facter operatingsystem | tr '[:upper:]' '[:lower:]')
operatingsystemmajrelease=$(bundle exec facter operatingsystemmajrelease)
hardwaremodel=$(bundle exec facter hardwaremodel)

for version in 1.6.0 1.7.0 2.0.0 2.1.0 2.2.0 2.3.0; do
  FACTER_GEM_VERSION="~> ${version}" bundle update
  minor_version=$(echo $version | cut -c1-3)
  output_dir="/vagrant/facts/${minor_version}"
  mkdir -p $output_dir
  FACTER_GEM_VERSION="~> ${version}" bundle exec facter -j | tee "${output_dir}/${operatingsystem}-${operatingsystemmajrelease}-${hardwaremodel}.facts"
done
