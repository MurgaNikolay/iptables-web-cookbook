
user node['iptables_web']['server']['user'] do
  home "/home/#{node['iptables_web']['server']['user']}"
  shell '/bin/bash'
  supports :manage_home => true
  action :create
  system true
end

include_recipe 'iptables_web::server_rvm' if node['iptables_web']['server']['install_method'] == 'rvm'
include_recipe 'iptables_web::server_source'
include_recipe 'iptables_web::server_setup_rvm'
include_recipe 'iptables_web::server_nginx'
