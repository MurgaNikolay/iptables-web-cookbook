default['iptables_web']['client']['user'] = 'iptables_web'
default['iptables_web']['client']['group'] = 'iptables_web'

default['iptables_web']['client']['custer_name'] = 'production'

#RVM
default['iptables_web']['client']['install_method'] = 'rvm'
default['iptables_web']['client']['rvm']['ruby'] = '2.0.0'
default['iptables_web']['client']['rvm']['gemset'] = 'iptables_web'

