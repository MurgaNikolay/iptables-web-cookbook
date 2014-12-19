default['iptables_web']['client']['user'] = 'iptables_web'
default['iptables_web']['client']['group'] = 'iptables_web'

default['iptables_web']['client']['custer_name'] = 'production'

#RVM
default['iptables_web']['client']['install_method'] = 'rvm'
default['iptables_web']['client']['rvm']['ruby'] = '2.0.0'
default['iptables_web']['client']['rvm']['gemset'] = 'iptables_web'
default['iptables_web']['client']['static_rules'] = [
  '-A INPUT -i lo -j ACCEPT',
  '-A FORWARD -i lo -j ACCEPT',
  '-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT',
  '-A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT'
]

