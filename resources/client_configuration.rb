actions :configure
default_action :configure

attribute :user, kind_of: [String]
attribute :group, kind_of: [String]
attribute :base_url, kind_of: [String, Proc]
attribute :access_token, kind_of: [String, Proc]
attribute :log_level, kind_of: [String, NilClass]

def config_dir
  ::File.join(user_home, '.iptables-web')
end

def user_home
  Etc.getpwnam(user).dir

rescue
  "/home/#{user}"
end

def static_rules(arg=nil)
  arg = { 'filter' => arg } if arg && arg.is_a?(Array)
  set_or_return(
    :static_rules,
    arg,
    kind_of: [Hash],
    default: {}
  )
end
