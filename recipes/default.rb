#
# Cookbook Name:: iptables-web-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# if node.iptables_web[:web][:rvm]

include_recipe 'iptables-web::source'
include_recipe 'iptables-web::nginx'
include_recipe 'iptables-web::rvm'
# else
#   include_recipe 'iptables_web::system_ruby'
# end
