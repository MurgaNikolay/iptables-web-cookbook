name             'iptables_web'
maintainer       'Nikolay Murga'
maintainer_email 'nikolay.m@randrmusic.com'
license          'All rights reserved'
description      'Installs/Configures iptables-web-cookbook'
long_description 'Installs/Configures iptables-web-cookbook'
version          '0.4.7'

depends          'build-essential'
depends          'mysql', '~> 6.0'
depends          'database', '~> 4.0'
depends          'chef_rvm', '~> 1.0'
depends          'mysql2_chef_gem', '~> 1.0'
depends          'nginx'
depends          'unicorn'
depends          'sudo'
depends          'git'
depends          'apt'

# depends          'elasticsearch'



