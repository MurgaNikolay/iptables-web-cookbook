include_recipe 'nginx'
include_recipe 'unicorn'

deploy_to = node['iptables_web']['server']['deploy_to']
shared_dir = ::File.join(deploy_to, 'shared')
current_dir = ::File.join(deploy_to, 'current')
unicorn_socket = File.join(shared_dir, 'tmp', 'sockets', 'unicorn.socket')

template '/etc/nginx/sites-available/iptables_web' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '754'
  variables(
    server_name: node['iptables_web']['server']['fqdn'],
    listen: node['iptables_web']['server']['listen'],
    backend: unicorn_socket,
    root: File.join(current_dir, 'public'),
    ssl_certificate: node['iptables_web']['server']['ssl_certificate'],
    ssl_key: node['iptables_web']['server']['ssl_key'],
    force_ssl: node['iptables_web']['server']['force_ssl']
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'iptables_web'




