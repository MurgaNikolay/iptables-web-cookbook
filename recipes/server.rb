include_recipe 'iptables_web::server_user'

if node['iptables_web']['server']['install_method'] == 'rvm'
  include_recipe 'iptables_web::server_rvm'
  include_recipe 'iptables_web::server_rvm_unicorn'
else
  include_recipe 'iptables_web::server_system_unicorn'
end

include_recipe 'iptables_web::server_deploy'
include_recipe 'iptables_web::server_nginx'
