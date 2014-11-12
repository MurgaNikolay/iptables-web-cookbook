include_recipe 'nginx'
include_recipe 'unicorn'

socket = File.join(node.iptables_web[:web][:deploy_to], 'tmp', 'sockets', 'unicorn.socket')

template '/etc/nginx/sites-available/iptables-web' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '754'
  variables(
    :server_name => node.iptables_web[:web][:fqdn],
    :listen => node.iptables_web[:web][:listen],
    :backend => socket,
    :root => File.join(node.iptables_web[:web][:deploy_to], 'public')
  )
  notifies :reload, 'service[nginx]'
end
nginx_site 'iptables-web'


unicorn_config File.join(node.iptables_web[:web][:deploy_to], 'config', 'unicorn.rb') do
  listen({socket => {}})
  pid File.join(node.iptables_web[:web][:deploy_to], 'tmp', 'pids', 'unicorn.pid')
  working_directory node.iptables_web[:web][:deploy_to]
  owner node.iptables_web[:web][:user]
  group node.iptables_web[:web][:group]
end

