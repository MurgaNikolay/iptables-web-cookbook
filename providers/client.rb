def whyrun_supported?
  true
end
include IptablesWebClientHelpers
use_inline_resources

action :configure do
  require 'rest_client'
  if Chef::Config['solo']
    if node['iptables_web']['server']['fqdn']
      server_node = node
    else
      Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
      Chef::Log.warn("If you did not set node['zabbix']['web']['fqdn'], the recipe will fail")
      return
    end
  else
    server_node = search(:node, 'recipe:iptables_web\:\:server OR recipes:iptables_web\:\:server').first
  end

  server_base_url = server_node['iptables_web']['server']['ssl'] ? 'https://' : 'http://'
  server_base_url << server_node['iptables_web']['server']['fqdn']
  server = ::File.join(server_base_url, 'api', 'registration.json')
  Chef::Log.info "Register node #{new_resource.name} on #{server}"
  result = RestClient.post(server,
    {node: {name: new_resource.name}}.to_json,
    {
      content_type: :json,
      accept: :json,
      'X-Authentication-Key' => new_resource.registration_key,
      'X-Authentication-Token' => new_resource.registration_token
    }
  )
  responce = JSON.parse(result.body)

  directory new_resource.config_dir do
    mode '0700'
    owner new_resource.user
    group new_resource.group
  end

  template ::File.join(new_resource.config_dir, 'config.yml') do
    source 'client_config.yml.erb'
    owner new_resource.user
    group new_resource.group
    mode '0600'
    variables ({
        base_url: server_base_url,
        access_token: responce['node']['token']
      })
  end

  cron 'iptables_web' do
    action :create
    user new_resource.user
    home new_resource.user_home
    command shell_command("cd #{new_resource.config_dir} && sudo iptables-restore -C < iptables-web")
  end
end


