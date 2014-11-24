chef_gem 'rest-client'

iptables_web_client node[:machinename] do
  server node[:iptables_web][:server][:fqdn]
  registration_token node[:iptables_web][:server][:registration][:token]
  registration_key node[:iptables_web][:server][:registration][:key]
  user node[:iptables_web][:client][:user]
  group node[:iptables_web][:client][:group]
  action :configure
  not_if "test -f #{::File.join('/home', node[:iptables_web][:client][:user], '.iptables-web', 'config.yml')}"
end
