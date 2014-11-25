module IptablesWebHelpers
  def server_ruby_string
    [
      node['iptables_web']['server']['rvm']['ruby'],
      node['iptables_web']['server']['rvm']['gemset']
    ].join '@'
  end

  def client_ruby_string
    [
      node['iptables_web']['client']['rvm']['ruby'],
      node['iptables_web']['client']['rvm']['gemset']
    ].join '@'
  end

  def install_rvm
    rvm node['iptables_web']['server']['user'] do
      rubies _ruby_string
      action :install
    end

    rvm_gemset 'iptables_web:gemset' do
      user node['iptables_web']['server']['user']
      ruby_string _ruby_string
    end
  end

  def rvm_shell(ruby_string, command)
    "bash -l -c 'rvm #{ruby_string} do #{command}'"
  end
end
