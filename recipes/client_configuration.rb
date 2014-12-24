iptables_web_client_configuration node['machinename'] do
  static_rules node['iptables_web']['client']['static_rules']
  user node['iptables_web']['client']['user']
  base_url lambda { node['iptables_web']['client']['server_base_url'] }
  access_token lambda { node['iptables_web']['client']['access_token'] }
  group node['iptables_web']['client']['group']
  action :configure
end
