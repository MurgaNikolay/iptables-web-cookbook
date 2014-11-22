#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

user node.iptables_web[:client][:user] do
  home "/home/#{node.iptables_web[:client][:user]}"
  shell '/bin/bash'
  supports :manage_home => true
  action :create
  system true
end

sudo node.iptables_web[:client][:user] do
  user      node.iptables_web[:client][:user]
  commands  ['/sbin/iptables-restore']
  nopasswd true
end
