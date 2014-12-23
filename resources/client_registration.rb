
actions :register
default_action :register
attribute :server_group, :kind_of => [String]
attribute :user, :kind_of => [String]
attribute :group, :kind_of => [String]
attribute :security_groups, :kind_of => [Array]
attribute :access_rules, :kind_of => [Array]
attribute :groups_access_rules, :kind_of => [Array]
attribute :client_node, default: node

def config_dir
  ::File.join(user_home, '.iptables-web')
end

def user_home
  Etc.getpwnam(user).dir
end

