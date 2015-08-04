#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'chef_rvm'

extend IptablesWebHelpers
_ruby_string = ruby_string(:client)
chef_rvm node['iptables_web']['client']['user'] do
  rubies _ruby_string
  action :install
end

chef_rvm_gemset 'iptables_web:gemset' do
  user node['iptables_web']['client']['user']
  ruby_string _ruby_string
end

chef_rvm_gem 'iptables_web::gem::iptables_web' do
  version node['iptables_web']['client']['version']
  gem 'iptables-web'
  user node['iptables_web']['client']['user']
  ruby_string _ruby_string
  action [ :install ]
end
