include_recipe 'build-essential'
include_recipe 'iptables_web::client_user'
if node['iptables_web']['client']['install_method'] == 'rvm'
  include_recipe "iptables_web::client_rvm"
else
  include_recipe 'iptables_web::client_system_ruby'
end
