def whyrun_supported?
  true
end
include IptablesWebClientHelpers
use_inline_resources

action :configure do
  file ::File.join(new_resource.config_dir, 'static_rules') do
    content new_resource.static_rules.join("\n")
    owner new_resource.user
    group new_resource.group
    mode '0600'
  end
end


