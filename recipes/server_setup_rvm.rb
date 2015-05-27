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
_ruby_string = server_ruby_string

chef_rvm_bash 'iptables_web:install' do
  environment 'RAILS_ENV' => node['iptables_web']['server']['rails_env']
  ruby_string _ruby_string
  user node['iptables_web']['server']['user']
  cwd node['iptables_web']['server']['deploy_to']
  code <<CODE
bundle install
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile
CODE
  subscribes :run, "git[#{node['iptables_web']['server']['deploy_to']}]"
  action :nothing
end

pid = File.join(node['iptables_web']['server']['deploy_to'], 'tmp', 'pids', 'unicorn.pid')
chef_rvm_execute 'iptables_web:unicorn:start' do
  environment 'RAILS_ENV' => node['iptables_web']['server']['rails_env']
  ruby_string _ruby_string
  command "bundle exec unicorn -c config/unicorn.rb -E #{node['iptables_web']['server']['rails_env']} -D"
  cwd node['iptables_web']['server']['deploy_to']
  user node['iptables_web']['server']['user']
  subscribes :run, 'chef_rvm_bash[iptables_web:install]', :immediately
  not_if "test -f #{pid}"
  only_if 'bundle check'
end

chef_rvm_execute 'iptables_web:unicorn:reload' do
  ruby_string _ruby_string
  user node['iptables_web']['server']['user']
  command "kill -HUP $(cat #{pid})"
  subscribes :run, 'chef_rvm_bash[iptables_web:install]'
  subscribes :run, 'template[iptables_web:config:database]'
  subscribes :run, 'template[iptables_web:config:settings]'
  subscribes :run, 'chef_rvm_execute[iptables_web:unicorn:start]', :delayed
  only_if "test -f #{pid}"
  action :nothing
end


