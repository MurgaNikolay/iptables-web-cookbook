#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'iptables_web::source'

deploy_to = node['iptables_web']['server']['deploy_to']
shared_dir = ::File.join(deploy_to, 'shared')
current_dir = ::File.join(deploy_to, 'current')
unicorn_pid = File.join(shared_dir, 'tmp', 'pids', 'unicorn.pid')

execute 'iptables_web:unicorn:start' do
  command "bundle exec unicorn -c config/unicorn.rb -E #{node['iptables_web']['server']['rails_env']} -D"
  cwd current_dir
  user node['iptables_web']['server']['user']
  environment({
      'HOME' => "/home/#{node['iptables_web']['server']['user']}",
      'USER' => node['iptables_web']['server']['user']
    })
  not_if "test -f #{unicorn_pid}"
end

execute 'iptables_web:unicorn:reload' do
  cwd current_dir
  user node['iptables_web']['server']['user']
  command "kill -HUP $(cat #{unicorn_pid})"
  environment({
      'HOME' => "/home/#{node['iptables_web']['server']['user']}",
      'USER' => node['iptables_web']['server']['user']
    })
  only_if "test -f #{unicorn_pid}"
  action :nothing
end

ruby_block 'iptables_web:start' do
  block {}
  notifies :run, 'execute[iptables_web:unicorn:start]'
end

ruby_block 'iptables_web:reload' do
  block {}
  notifies :run, 'execute[iptables_web:unicorn:reload]'
end
