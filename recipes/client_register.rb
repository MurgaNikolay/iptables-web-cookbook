chef_gem 'rest-client'

iptables_web_client_registration node['machinename'] do
  server_group node['iptables_web']['client']['registration']['server_group']
  access_rules node['iptables_web']['client']['registration']['access_rules']
  groups_access_rules node['iptables_web']['client']['registration']['groups_access_rules']
  security_groups node['iptables_web']['client']['registration']['security_groups']
  user node['iptables_web']['client']['user']
  group node['iptables_web']['client']['group']
  action :register
end
