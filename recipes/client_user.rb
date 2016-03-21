#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

user node['iptables_web']['client']['user'] do
  # home "/home/#{node['iptables_web']['client']['user']}"
  # shell '/bin/bash'
  # supports :manage_home => true
  action :create
  system true
end

sudo node['iptables_web']['client']['user'] do
  user      node['iptables_web']['client']['user']
  commands  ['/sbin/iptables-restore', '/sbin/iptables', '/sbin/iptables-save']
  nopasswd true
end

directory ::File.join("/home/#{node['iptables_web']['client']['user']}", '.iptables-web')  do
  mode '0700'
  owner node['iptables_web']['client']['user']
  group node['iptables_web']['client']['group']
end
