
actions :configure
default_action :configure
attribute :server, :kind_of => [String]
attribute :user, :kind_of => [String]
attribute :group, :kind_of => [String]
attribute :registration_key, :kind_of => [String]
attribute :registration_token, :kind_of => [String]

def config_dir
  ::File.join(user_home, '.iptables-web')
end

def user_home
  Etc.getpwnam(user).dir
end
