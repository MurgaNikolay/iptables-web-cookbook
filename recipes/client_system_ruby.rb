#
# Cookbook Name:: iptables_web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

gem_package 'iptables_web' do
  version version node['iptables_web']['client']['version']
end
