user node.iptables_web[:web][:user] do
  home "/home/#{node.iptables_web[:web][:user]}"
  shell '/bin/bash'
  supports :manage_home => true
  action :create
  system true
end

directory node.iptables_web[:web][:deploy_to] do
  owner node.iptables_web[:web][:user]
  group node.iptables_web[:web][:group]
  recursive true
  mode '0755'
  action :create
end

['tmp/sockets', 'tmp/pids'].each do |dir|
  directory File.join node.iptables_web[:web][:deploy_to], dir do
    owner node.iptables_web[:web][:user]
    group node.iptables_web[:web][:group]
    recursive true
    mode '0755'
    action :create
  end
end

database_config = template "#{node.iptables_web[:web][:deploy_to]}/config/database.yml" do
  source 'database.yml.erb'
  action :nothing
end
#
settings = template "#{node.iptables_web[:web][:deploy_to]}/config/settings.yml" do
  source 'settings.yml.erb'
  action :nothing
end

# #clone code
git node.iptables_web[:web][:deploy_to] do
  repository node.iptables_web[:web][:repo]
  revision node.iptables_web[:web][:revision]
  action :sync
  user node.iptables_web[:web][:user]
  group node.iptables_web[:web][:group]
  #create configs
  notifies :create, database_config, :immediately
  notifies :create, settings, :immediately
end

unless node[:mysql][:server_root_password]
  node.normal[:mysql][:server_root_password] = secure_password
end

root_connection = {
  :host => node.iptables_web[:web][:database][:host],
  :port => node.iptables_web[:web][:database][:port].to_i || node.normal[:mysql][:port].to_i,
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

puts root_connection
mysql_database node.iptables_web[:web][:database][:name] do
  connection root_connection
end

mysql_database_user node.iptables_web[:web][:database][:username] do
  connection root_connection
  password node.iptables_web[:web][:database][:password]
  database_name node.iptables_web[:web][:database][:name]
  #host new_resource.allowed_user_hosts
  privileges [:select, :update, :insert, :create, :drop, :delete, :alter, :index]
  action :nothing
end
