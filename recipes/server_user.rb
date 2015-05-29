user node['iptables_web']['server']['user'] do
  home "/home/#{node['iptables_web']['server']['user']}"
  shell '/bin/bash'
  supports :manage_home => true
  action :create
  system true
end
