include_recipe 'git'

directory node['iptables_web']['server']['deploy_to'] do
  owner node['iptables_web']['server']['user']
  group node['iptables_web']['server']['group']
  recursive true
  mode '0755'
  action :create
end

#clone code
_git = git node['iptables_web']['server']['deploy_to'] do
  repository node['iptables_web']['server']['repo']
  revision node['iptables_web']['server']['revision']
  action :sync
  user node['iptables_web']['server']['user']
  group node['iptables_web']['server']['group']
end

%w(tmp tmp/sockets tmp/pids).each do |dir|
  directory File.join node['iptables_web']['server']['deploy_to'], dir do
    owner node['iptables_web']['server']['user']
    group node['iptables_web']['server']['group']
    # recursive true
    mode '0755'
    subscribes :create, _git, :immediately
  end
end

socket = File.join(node['iptables_web']['server']['deploy_to'], 'tmp', 'sockets', 'unicorn.socket')
unicorn_config File.join(node['iptables_web']['server']['deploy_to'], 'config', 'unicorn.rb') do
  listen({socket => {}})
  pid File.join(node['iptables_web']['server']['deploy_to'], 'tmp', 'pids', 'unicorn.pid')
  stderr_path File.join(node['iptables_web']['server']['deploy_to'], 'log', "#{node['iptables_web']['server']['rails_env']}.log")
  stdout_path File.join(node['iptables_web']['server']['deploy_to'], 'log', "#{node['iptables_web']['server']['rails_env']}.log")
  working_directory node['iptables_web']['server']['deploy_to']
  owner node['iptables_web']['server']['user']
  group node['iptables_web']['server']['group']
end

template 'iptables_web:config:database' do
  path "#{node['iptables_web']['server']['deploy_to']}/config/database.yml"
  source 'database.yml.erb'
  subscribes :create, _git, :immediately
end

template 'iptables_web:config:settings' do
  path "#{node['iptables_web']['server']['deploy_to']}/config/settings.yml"
  source 'settings.yml.erb'
  subscribes :create, _git,  :immediately
end

unless node['mysql']['server_root_password']
  node.normal['mysql']['server_root_password'] = secure_password
end

root_connection = {
  :host => node['iptables_web']['server']['database']['host'],
  :port => node['iptables_web']['server']['database']['port'].to_i || node.normal['mysql']['port'].to_i,
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node['iptables_web']['server']['database']['name'] do
  connection root_connection
  action :create
end

mysql_database_user node['iptables_web']['server']['database']['username'] do
  connection root_connection
  password node['iptables_web']['server']['database']['password']
  database_name node['iptables_web']['server']['database']['name']
  #host new_resource.allowed_user_hosts
  privileges [:select, :update, :insert, :create, :drop, :delete, :alter, :index]
  action [:create, :grant]
end
