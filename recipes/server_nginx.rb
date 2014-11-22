include_recipe 'nginx'
include_recipe 'unicorn'

socket = File.join(node.iptables_web[:server][:deploy_to], 'tmp', 'sockets', 'unicorn.socket')

template '/etc/nginx/sites-available/iptables_web' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '754'
  variables(
    :server_name => node.iptables_web[:server][:fqdn],
    :listen => node.iptables_web[:server][:listen],
    :backend => socket,
    :root => File.join(node.iptables_web[:server][:deploy_to], 'public')
  )
  notifies :reload, 'service[nginx]'
end
nginx_site 'iptables_web'


unicorn_config File.join(node.iptables_web[:server][:deploy_to], 'config', 'unicorn.rb') do
  listen({socket => {}})
  pid File.join(node.iptables_web[:server][:deploy_to], 'tmp', 'pids', 'unicorn.pid')
  working_directory node.iptables_web[:server][:deploy_to]
  owner node.iptables_web[:server][:user]
  group node.iptables_web[:server][:group]
end

