include_recipe 'git'
extend IptablesWebHelpers

deploy_to = node['iptables_web']['server']['deploy_to']
shared_dir = ::File.join(deploy_to, 'shared')
current_dir = ::File.join(deploy_to, 'current')

directory deploy_to do
  owner node['iptables_web']['server']['user']
  group node['iptables_web']['server']['group']
  recursive true
  mode '0755'
  action :create
end

%w(/ tmp tmp/sockets tmp/pids config log).each do |dir|
  directory ::File.join(shared_dir, dir) do
    owner node['iptables_web']['server']['user']
    group node['iptables_web']['server']['group']
    mode '0755'
  end
end

unicorn_socket = File.join(shared_dir, 'tmp', 'sockets', 'unicorn.socket')
unicorn_pid = File.join(shared_dir, 'tmp', 'pids', 'unicorn.pid')

# Unicorn config
unicorn_config File.join(shared_dir, 'config', 'unicorn.rb') do
  listen({ unicorn_socket => {} })
  pid unicorn_pid
  working_directory current_dir
  stderr_path File.join(shared_dir, 'log', "#{node['iptables_web']['server']['rails_env']}.log")
  stdout_path File.join(shared_dir, 'log', "#{node['iptables_web']['server']['rails_env']}.log")
  owner node['iptables_web']['server']['user']
  group node['iptables_web']['server']['group']
  notifies :run, 'ruby_block[iptables_web:reload]'
end

# Database config
template 'iptables_web:config:database' do
  path "#{shared_dir}/config/database.yml"
  source 'database.yml.erb'
  variables(
    rails_env: node['iptables_web']['server']['rails_env'],
    database: node['iptables_web']['server']['database']['name'],
    host: node['iptables_web']['server']['database']['host'],
    username: node['iptables_web']['server']['database']['username'],
    password: node['iptables_web']['server']['database']['password']
  )
  notifies :run, 'ruby_block[iptables_web:reload]'
end

# Settings config
template 'iptables_web:config:settings' do
  path "#{shared_dir}/config/settings.yml"
  source 'settings.yml.erb'
  variables(
    google_key: node['iptables_web']['server']['google']['key'],
    google_secret: node['iptables_web']['server']['google']['secret'],
    google_domains: node['iptables_web']['server']['google']['domains'],
    acl: node['iptables_web']['server']['google']['acl'],
    registration_key: node['iptables_web']['server']['registration']['key'],
    registration_token: node['iptables_web']['server']['registration']['token'],
    registration_user: node['iptables_web']['server']['registration']['user'],
  )
  notifies :run, 'ruby_block[iptables_web:reload]'
end

# create database
root_connection = {
  :host => node['iptables_web']['server']['mysql']['host'],
  :port => node['iptables_web']['server']['mysql']['port'],
  :username => 'root',
  :password => node['iptables_web']['server']['mysql']['initial_root_password']
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

deploy node['iptables_web']['server']['deploy_to'] do
  provider Chef::Provider::Deploy::Revision if node['iptables_web']['server']['deploy_strategy'].to_s == 'revision'
  repo node['iptables_web']['server']['repo']
  revision node['iptables_web']['server']['revision']
  user node['iptables_web']['server']['user']
  group node['iptables_web']['server']['group']
  environment rvm_env(:server, 'RAILS_ENV' => node['iptables_web']['server']['rails_env'])
  purge_before_symlink %w{log tmp/pids tmp/sockets public/system}

  symlink_before_migrate({
      'config/unicorn.rb' => 'config/unicorn.rb',
      'config/database.yml' => 'config/database.yml',
      'config/settings.yml' => 'config/settings.yml'
    })
  symlinks({
      'log' => 'log',
      'tmp/pids' => 'tmp/pids',
      'tmp/sockets' => 'tmp/sockets'
    })
  shallow_clone false
  migrate true
  migration_command([
      rvm_command(:server, 'bundle install'),
      rvm_command(:server, 'bundle exec rake db:migrate'),
      rvm_command(:server, 'bundle exec rake assets:precompile'),
      rvm_command(:server, 'bundle install'),
    ].join(' && ')
  )
  notifies :run, 'ruby_block[iptables_web:start]'
  notifies :run, 'ruby_block[iptables_web:reload]'
  keep_releases 3
end
