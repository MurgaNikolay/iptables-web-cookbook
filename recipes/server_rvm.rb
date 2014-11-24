#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
extend IptablesWebHelpers

_ruby_string = server_ruby_string

rvm node[:iptables_web][:server][:user] do
  rubies _ruby_string
  action :install
end

rvm_gemset 'iptables_web:gemset' do
  user node[:iptables_web][:server][:user]
  ruby_string _ruby_string
end

rvm_gem 'iptables_web::gem::iptables_web' do
  gem 'iptables_web'
  user node[:iptables_web][:server][:user]
  ruby_string _ruby_string
  action :install
end


pid = File.join(node[:iptables_web][:server][:deploy_to], 'tmp', 'pids', 'unicorn.pid')

_environment ={
  'HOME' => File.join('/home', node[:iptables_web][:server][:user]),
  'USER' => node[:iptables_web][:server][:user],
  'RAILS_ENV' => node[:iptables_web][:server][:rails_env]
}

_cmd = rvm_shell(_ruby_string, 'bundle install')
execute 'iptables_web:bundle:install' do
  command _cmd
  cwd node[:iptables_web][:server][:deploy_to]
  user node[:iptables_web][:server][:user]
  environment _environment
  action :nothing
  subscribes :run, "git[#{node[:iptables_web][:server][:deploy_to]}]", :immediately
end

_cmd = rvm_shell(_ruby_string, 'bundle exec rake db:migrate')
execute 'iptables_web:db:migrate' do
  command _cmd
  cwd node[:iptables_web][:server][:deploy_to]
  user node[:iptables_web][:server][:user]
  environment _environment
  action :nothing
  subscribes :run, 'execute[iptables_web:bundle:install]', :immediately
end

_cmd = rvm_shell(_ruby_string, 'bundle exec rake db:seed')
execute 'iptables_web:db:seed' do
  command _cmd
  cwd node[:iptables_web][:server][:deploy_to]
  user node[:iptables_web][:server][:user]
  environment _environment
  action :nothing
  subscribes :run, 'execute[iptables_web:db:migrate]', :immediately
end

_cmd = rvm_shell(_ruby_string, 'bundle exec rake assets:precompile')
execute 'iptables_web:assets:precompile' do
  command _cmd
  cwd node[:iptables_web][:server][:deploy_to]
  user node[:iptables_web][:server][:user]
  environment _environment
  action :nothing
  subscribes :run, 'execute[iptables_web:bundle:install]', :immediately
end

_cmd = rvm_shell(_ruby_string, "bundle exec unicorn -c config/unicorn.rb -E #{node[:iptables_web][:server][:rails_env]} -D")
execute 'iptables_web:unicorn:start' do
  command _cmd
  cwd node[:iptables_web][:server][:deploy_to]
  user node[:iptables_web][:server][:user]
  environment _environment
  subscribes :run, 'execute[iptables_web:assets:precompile]', :immediately
  not_if "test -f #{pid}"
end

execute 'iptables_web:unicorn:reload' do
  command "kill -HUP $(cat #{pid})"
  subscribes :run, 'execute[iptables_web:assets:precompile]'
  subscribes :run, 'execute[iptables_web:bundle:install]'
  subscribes :run, 'execute[iptables_web:db:migrate]'
  action :nothing
  only_if "test -f #{pid}"
end
