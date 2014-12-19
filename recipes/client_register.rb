chef_gem 'rest-client'

iptables_web_client node['machinename'] do
  server node['iptables_web']['server']['fqdn']
  static_rules node['iptables_web']['client']['static_rules']
  user node['iptables_web']['client']['user']
  group node['iptables_web']['client']['group']
  action :register, :configure
end
