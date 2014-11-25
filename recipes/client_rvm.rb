#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

extend IptablesWebHelpers
_ruby_string = client_ruby_string
rvm node['iptables_web']['client']['user'] do
  rubies _ruby_string
  action :install
end

rvm_gemset 'iptables_web:gemset' do
  user node['iptables_web']['client']['user']
  ruby_string _ruby_string
end

rvm_gem 'iptables_web::gem::iptables_web' do
  gem 'iptables_web'
  user node['iptables_web']['client']['user']
  ruby_string _ruby_string
  action :install
end
