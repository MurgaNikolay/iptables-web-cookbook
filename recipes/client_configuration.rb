iptables_web_client_configuration node['machinename'] do
  static_rules node['iptables_web']['client']['static_rules']
  user node['iptables_web']['client']['user']
  group node['iptables_web']['client']['group']
  action :configure
end
