default['iptables_web']['server']['repo'] = 'https://github.com/MurgaNikolay/iptables-web.git'
default['iptables_web']['server']['revision'] = 'master'
default['iptables_web']['server']['rails_env'] = 'production'
default['iptables_web']['server']['user'] = 'iptables_web'
default['iptables_web']['server']['group'] = 'iptables_web'
default['iptables_web']['server']['tag'] = 'production'

#RVM
default['iptables_web']['server']['install_method'] = 'rvm'
default['iptables_web']['server']['rvm']['ruby'] = '2.0.0'
default['iptables_web']['server']['rvm']['gemset'] = 'iptables_web'

#auth
default['iptables_web']['server']['google']['key'] = ''
default['iptables_web']['server']['google']['secret'] = ''
default['iptables_web']['server']['google']['domains'] = []
default['iptables_web']['server']['acl'] = []

#for authomatic registration
default['iptables_web']['server']['registration']['user'] = 'user@forregistration.com'
default['iptables_web']['server']['registration']['key'] = 'userkey'
default['iptables_web']['server']['registration']['token'] = 'usertoken'

#nginx
default['iptables_web']['server']['fqdn'] = 'access.example.com'
default['iptables_web']['server']['listen'] = '80'
default['iptables_web']['server']['ssl'] = false
# default['iptables_web']['server']['ssl'] = true
# default['iptables_web']['server']['ssl'] = true
default['iptables_web']['server']['deploy_to'] = '/var/www/iptables-web'


# default['iptables_web']['server']['ssl'] = true
# default['iptables_web']['server']['ssl_cert'] = true
# default['iptables_web']['server']['ssl_key'] = true

#database
default['iptables_web']['server']['database']['host'] = 'localhost'
default['iptables_web']['server']['database']['name'] = 'access'
default['iptables_web']['server']['database']['username'] = 'access'
default['iptables_web']['server']['database']['password'] = 'access'
default['iptables_web']['server']['database']['port'] = 3306


