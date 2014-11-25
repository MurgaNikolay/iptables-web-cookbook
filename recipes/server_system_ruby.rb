#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'iptables_web::source'


execute 'bundle install' do
  command "bundle install"
  cwd '/var/www/iptables_web'
  user 'iptables_web'
  environment({
    'HOME' => '/home/iptables_web',
    'USER' => node['iptables_web']['server']['user']
  })
  not_if "bundle check"
end

pid = File.join(node['iptables_web']['server']['deploy_to'], 'tmp', 'pids', 'unicorn.pid')
execute 'run unicorn' do
  command "bundle exec unicorn -c config/unicorn.rb -E #{node['iptables_web']['server']['rails_env']} -D"
  cwd '/var/www/iptables_web'
  user 'iptables_web'
  environment({
    'HOME' => '/home/iptables_web',
    'USER' => node['iptables_web']['server']['user']
  })
  not_if "test -f #{pid}"
end

