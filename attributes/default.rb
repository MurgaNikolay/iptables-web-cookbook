
default['iptables_web']['web']['repo'] = 'https://github.com/MurgaNikolay/iptables-web.git'
default['iptables_web']['web']['revision'] = 'master'
default['iptables_web']['web']['rails_env'] = 'production'
default['iptables_web']['web']['user'] = 'iptables_web'
default['iptables_web']['web']['group'] = 'iptables_web'

#RVM
default['iptables_web']['web']['install_method'] = 'rvm'
default['iptables_web']['web']['rvm']['ruby'] = '2.0.0'
default['iptables_web']['web']['rvm']['gemset'] = 'iptables_web'

#auth
default['iptables_web']['web']['google']['key'] = ''
default['iptables_web']['web']['google']['secret'] = ''
default['iptables_web']['web']['google']['domains'] = []
default['iptables_web']['web']['acl'] = []

#for authomatic registration
default['iptables_web']['api']['token'] = 'asdksajkdhasjkdhaskjhdjkasdhkas'
default['iptables_web']['api']['user'] = 'user@example.com'

#nginx
default['iptables_web']['web']['fqdn'] = 'access.example.com'
default['iptables_web']['web']['port'] = '80'
default['iptables_web']['web']['deploy_to'] = '/var/www/iptables-web'


# default['iptables_web']['web']['ssl'] = true
# default['iptables_web']['web']['ssl_cert'] = true
# default['iptables_web']['web']['ssl_key'] = true

#database
default['iptables_web']['web']['database']['host'] = 'localhost'
default['iptables_web']['web']['database']['name'] = 'access'
default['iptables_web']['web']['database']['username'] = 'access'
default['iptables_web']['web']['database']['password'] = 'access'
default['iptables_web']['web']['database']['port'] = 3306
