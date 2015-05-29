
#database
mysql = node['iptables_web']['server']['mysql']

mysql_service mysql['name'] do
  bind_address mysql['bind_address']
  port mysql['port']
  initial_root_password mysql['initial_root_password']
  action [:create, :start]
end

link '/var/run/mysqld/mysqld.sock' do
  to "/var/run/mysql-#{mysql['name']}/mysqld.sock"
end if mysql['link_to_default']


mysql_client mysql['name'] do
  action :create
end

# for database
mysql2_chef_gem 'default' do
  action :install
end
