include_recipe 'nginx'
include_recipe 'unicorn'

socket = File.join(node['iptables_web']['server']['deploy_to'], 'tmp', 'sockets', 'unicorn.socket')

template '/etc/nginx/sites-available/iptables_web' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '754'
  variables(
    server_name: node['iptables_web']['server']['fqdn'],
    listen: node['iptables_web']['server']['listen'],
    backend: socket,
    root: File.join(node['iptables_web']['server']['deploy_to'], 'public'),
    ssl_certificate: node['iptables_web']['server']['ssl_certificate'],
    ssl_key: node['iptables_web']['server']['ssl_key'],
    force_ssl: node['iptables_web']['server']['force_ssl']
  )
  notifies :reload, 'service[nginx]'
end
nginx_site 'iptables_web'




