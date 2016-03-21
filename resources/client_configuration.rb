actions :configure
default_action :configure

attribute :user, kind_of: [String]
attribute :group, kind_of: [String]
attribute :base_url, kind_of: [String, Proc]
attribute :access_token, kind_of: [String, Proc]
attribute :log_level, kind_of: [String, NilClass]
attribute :log_path, kind_of: [String], default: '/var/log/iptables-web/update.log'
attribute :config_dir, kind_of: [String], default: '/etc/iptables-web'

# def user_home
#   Etc.getpwnam(user).dir
# rescue
#   "/home/#{user}"
# end

def static_rules(arg=nil)
  arg = { 'filter' => arg } if arg && arg.is_a?(Array)
  set_or_return(
    :static_rules,
    arg,
    kind_of: [Hash],
    default: {}
  )
end
