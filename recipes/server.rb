include_recipe 'iptables_web::server_source'
if node[:iptables_web][:server][:install_method]
  include_recipe 'iptables_web::server_rvm'
else
   include_recipe 'iptables_web::server_system_ruby'
end

include_recipe 'iptables_web::server_nginx'
