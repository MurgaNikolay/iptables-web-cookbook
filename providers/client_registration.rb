def whyrun_supported?
  true
end
include IptablesWebClientHelpers
include Chef::DSL::IncludeRecipe
use_inline_resources

action :register do
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
    {
      node: {
        name: new_resource.name,
        security_groups: new_resource.security_groups,
        access_rules: new_resource.access_rules,
        groups_access_rules: new_resource.groups_access_rules
      }
    }.to_json,
    {
      content_type: :json,
      accept: :json,
      'X-Authentication-Key' => server_node['iptables_web']['server']['registration']['key'],
      'X-Authentication-Token' => server_node['iptables_web']['server']['registration']['token']
    }
  )
  responce = JSON.parse(result.body)
  # Store access token to node
  new_resource.client_node.normal['iptables_web']['client']['server_base_url'] = server_base_url
  new_resource.client_node.normal['iptables_web']['client']['access_token'] = responce['node']['token']
  include_recipe 'iptables_web::client_configuration'
end

