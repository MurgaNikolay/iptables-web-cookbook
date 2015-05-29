module IptablesWebHelpers
  def ruby_string(side)
    [
      node['iptables_web'][side]['rvm']['ruby'],
      node['iptables_web'][side]['rvm']['gemset']
    ].join '@'
  end

  def rvm_command(side = :server, command)
    return command unless rvm?(side)
    "bash -l -c 'rvm #{ruby_string(side)} do #{command}'"
  end

  def rvm?(side = :server)
    node['iptables_web'][side]['install_method'] == 'rvm'
  end

  def rvm_env(side, env={})
    {
      'HOME' => "/home/#{node['iptables_web'][side]['user']}",
      'USER' => node['iptables_web'][side]['user']
    }.merge!(env)
  end
end

class Chef
  class Recipe
    extend IptablesWebHelpers
    include IptablesWebHelpers
  end
end

class Chef
  class Resource
    class Deploy
      include IptablesWebHelpers
    end
  end
end
