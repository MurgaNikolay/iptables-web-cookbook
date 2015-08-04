default['iptables_web']['client']['version'] = '0.3.0'
default['iptables_web']['client']['user'] = 'iptables_web'
default['iptables_web']['client']['group'] = 'iptables_web'

default['iptables_web']['client']['custer_name'] = 'production'

# RVM
default['iptables_web']['client']['install_method'] = 'rvm'
default['iptables_web']['client']['rvm']['ruby'] = '2.0.0'
default['iptables_web']['client']['rvm']['gemset'] = 'iptables_web'

default['iptables_web']['client']['static_rules']['filter'] = [
  '-A INPUT -i lo -j ACCEPT',
  '-A FORWARD -i lo -j ACCEPT',
  '-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT',
  '-A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT',
  '-A INPUT -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT',
  '-A OUTPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j ACCEPT'
]

default['iptables_web']['client']['server_base_url'] = nil
default['iptables_web']['client']['access_token'] = nil
default['iptables_web']['client']['registration']['server_tag'] = 'production'
default['iptables_web']['client']['registration']['access_rules'] = []
default['iptables_web']['client']['registration']['groups_access_rules'] = []
default['iptables_web']['client']['registration']['security_groups'] = []
