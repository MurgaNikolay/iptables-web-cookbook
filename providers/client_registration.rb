def whyrun_supported?
  true
end

include IptablesWebClientHelpers
include Chef::DSL::IncludeRecipe
use_inline_resources

action :register do
  require 'rest_client'
  server_node = search(:node, 'recipe:iptables_web\:\:server OR recipes:iptables_web\:\:server').first
  server_base_url = (server_node['iptables_web']['server']['force_ssl'] || server_node['iptables_web']['server']['ssl_key']) ? 'https://' : 'http://'
  server_base_url << server_node['iptables_web']['server']['fqdn']
  registration_url = ::File.join(server_base_url, 'api', 'registration.json')
  Chef::Log.info "Register node #{new_resource.name} on #{registration_url}"

  puts({
    content_type: :json,
    accept: :json,
    'X-Authentication-Key' => server_node['iptables_web']['server']['registration']['key'],
    'X-Authentication-Token' => server_node['iptables_web']['server']['registration']['token']
  })

  result = RestClient::Request.execute(
    method: :post,
    url: registration_url,
    payload: {
      node: {
        name: new_resource.name,
        security_groups: new_resource.security_groups,
        access_rules: new_resource.access_rules,
        groups_access_rules: new_resource.groups_access_rules
      }
    }.to_json,
    headers: {
      content_type: :json,
      accept: :json,
      'X-Authentication-Key' => server_node['iptables_web']['server']['registration']['key'],
      'X-Authentication-Token' => server_node['iptables_web']['server']['registration']['token']
    },
    verify_ssl: false
  )


  responce = JSON.parse(result.body)
  # Store access token to node
  new_resource.client_node.normal['iptables_web']['client']['server_base_url'] = server_base_url
  new_resource.client_node.normal['iptables_web']['client']['access_token'] = responce['node']['token']
  include_recipe 'iptables_web::client_configuration'
end

