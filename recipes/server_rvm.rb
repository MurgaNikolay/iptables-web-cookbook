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

ruby_rvm node['iptables_web']['server']['user'] do
  rubies _ruby_string
  action :install
end

ruby_rvm_gemset 'iptables_web:gemset' do
  user node['iptables_web']['server']['user']
  ruby_string _ruby_string
end

ruby_rvm_gem 'iptables_web::gem::bundler' do
  gem 'bundler'
  user node['iptables_web']['server']['user']
  ruby_string _ruby_string
  action :install
end



