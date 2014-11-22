module IptablesWebClientHelpers
  def ruby_string
    [
      node.iptables_web[:client][:rvm][:ruby],
      node.iptables_web[:client][:rvm][:gemset]
    ].join '@'
  end

  def shell_command(command)
    if node.iptables_web[:client][:install_method]== 'rvm'
      "bash -l -c 'rvm #{ruby_string} do #{command}'"
    else
      command
    end
  end
end
