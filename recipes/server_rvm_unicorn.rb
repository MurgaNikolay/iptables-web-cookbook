#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
extend IptablesWebHelpers
_ruby_string = ruby_string(:server)

deploy_to = node['iptables_web']['server']['deploy_to']
shared_dir = ::File.join(deploy_to, 'shared')
current_dir = ::File.join(deploy_to, 'current')
unicorn_pid = File.join(shared_dir, 'tmp', 'pids', 'unicorn.pid')

chef_rvm_execute 'iptables_web:unicorn:start' do
  user node['iptables_web']['server']['user']
  ruby_string _ruby_string
  environment 'RAILS_ENV' => node['iptables_web']['server']['rails_env']
  command "bundle exec unicorn -c config/unicorn.rb -E #{node['iptables_web']['server']['rails_env']} -D"
  cwd current_dir
  not_if "test -f #{unicorn_pid}"
  only_if 'bundle check'
end

execute 'iptables_web:unicorn:reload' do
  user node['iptables_web']['server']['user']
  cwd current_dir
  command "kill -HUP $(cat #{unicorn_pid})"
  only_if "test -f #{unicorn_pid}"
  action :nothing
end

ruby_block 'iptables_web:start' do
  block {}
  notifies :run, 'chef_rvm_execute[iptables_web:unicorn:start]'
  action :nothing
end


ruby_block 'iptables_web:reload' do
  block {}
  notifies :run, 'execute[iptables_web:unicorn:reload]'
  action :nothing
end


