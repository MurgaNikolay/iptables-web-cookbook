include_recipe 'build-essential'
include_recipe 'iptables_web::client_user'

package 'ruby1.9.3'
gem_package 'iptables-web' do
  version version node['iptables_web']['client']['version']
end
