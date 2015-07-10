def whyrun_supported?
  true
end
include IptablesWebClientHelpers
use_inline_resources

action :configure do

  template ::File.join(new_resource.config_dir, 'static_rules') do
    source 'static_rules.erb'
    variables(static_rules: new_resource.static_rules)
    owner new_resource.user
    group new_resource.group
    mode '0600'
  end

  template ::File.join(new_resource.config_dir, 'config.yml') do
    source 'client_config.yml.erb'
    owner new_resource.user
    group new_resource.group
    mode '0600'
    variables ({
        base_url: new_resource.base_url,
        access_token: new_resource.access_token
      })
  end

  cron 'iptables_web' do
    action :create
    user new_resource.user
    home new_resource.user_home
    command shell_command("iptables-web")
  end
end


