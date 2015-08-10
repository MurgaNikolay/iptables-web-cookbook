default['iptables_web']['server']['repo'] = 'https://github.com/MurgaNikolay/iptables-web.git'
default['iptables_web']['server']['revision'] = 'v0.3.1'
default['iptables_web']['server']['deploy_strategy'] = :revision
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
default['iptables_web']['server']['force_ssl'] = false
default['iptables_web']['server']['ssl_certificate'] = false
default['iptables_web']['server']['ssl_key'] = false
default['iptables_web']['server']['deploy_to'] = '/var/www/iptables-web'


#database
default['iptables_web']['server']['mysql']['initial_root_password'] = 'mysqldefaultrootpassword'
default['iptables_web']['server']['mysql']['port'] = '3306'
default['iptables_web']['server']['mysql']['bind_address'] = '127.0.0.1'
default['iptables_web']['server']['mysql']['name'] = 'iptables_web'
default['iptables_web']['server']['mysql']['link_to_default'] = true

# application config

default['iptables_web']['server']['database']['host'] = '127.0.0.1'
default['iptables_web']['server']['database']['name'] = 'access'
default['iptables_web']['server']['database']['username'] = 'access'
default['iptables_web']['server']['database']['password'] = 'access'
default['iptables_web']['server']['database']['port'] = 3306


