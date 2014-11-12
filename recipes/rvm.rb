#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'iptables-web::source'

_ruby_string = [
  node.iptables_web[:web][:rvm][:ruby],
  node.iptables_web[:web][:rvm][:gemset]
].join '@'

rvm node.iptables_web[:web][:user] do
  rubies _ruby_string
  action :install
end

rvm_gemset 'iptables_web:gemset' do
  user node.iptables_web[:web][:user]
  ruby_string _ruby_string
end

execute 'bundle install' do
  command "bash -l -c 'rvm #{_ruby_string} do bundle install'"
  cwd '/var/www/iptables-web'
  user 'iptables_web'
  environment({
    'HOME' => '/home/iptables_web',
    'USER' => node.iptables_web[:web][:user]
  })
  not_if "bash -l -c 'rvm #{_ruby_string} do bundle check'"
end

pid = File.join(node.iptables_web[:web][:deploy_to], 'tmp', 'pids', 'unicorn.pid')
execute 'run unicorn' do
  command "bash -l -c 'rvm #{_ruby_string} do bundle exec unicorn -c config/unicorn.rb -E #{node.iptables_web[:web][:rails_env]} -D'"
  cwd '/var/www/iptables-web'
  user 'iptables_web'
  environment({
    'HOME' => '/home/iptables_web',
    'USER' => node.iptables_web[:web][:user]
  })
  not_if "test -f #{pid}"
end

  # bundle = rvm_execute "bundle install" do
  #    user node.iptables_web[:web][:user]
  #    path node.iptables_web[:web][:deploy_to]
  #    ruby_string _ruby_string
  #    action :do
  # end

  # migration = rvm_execute 'bundle exec rake db:migrate' do
  #   user node.iptables_web[:web][:user]
  #   ruby_string _ruby_string
  #   action :nothing
  #   subscribes :do, bundle
  # end

  # unicorn = rvm_execute "bundle exec unicorn -c config/unicorn.rb -E #{node.iptables_web[:web][:rails_env]} -D" do
  #   user node.iptables_web[:web][:user]
  #   ruby_string _ruby_string
  #   action :nothing
  #   subscribes :do, migration
  # end



