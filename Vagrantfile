# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'iptables-web-cookbook-berkshelf'

  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #
  #   $ vagrant plugin install vagrant-omnibus
  #
  # if Vagrant.has_plugin?('Omnibus')
  config.omnibus.chef_version = :latest
  # end

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = 'chef/ubuntu-14.04'


  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :private_network, type: 'dhcp', ip: '192.168.23.10'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder '/Users/nikolay/Projects/iptables-web', '/iptables_web_repo'

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.trigger.before :reload, stdout: true do
    puts "Remove 'synced_folders' file for #{@machine.name}"
    `rm .vagrant/machines/#{@machine.name}/virtualbox/synced_folders`
  end
  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"


  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.vm.provision :hostmanager
  end

  # HA
  config.vm.define 'server' do |es|
    es.vm.hostname = 'iptables-server'
    es.vm.network :private_network, ip: '35.35.35.31'
    es.hostmanager.aliases = %w(iptables-server.dev) if Vagrant.has_plugin?('vagrant-hostmanager')

    es.vm.provision :chef_zero do |chef|
      # puts attrs
      chef.cookbooks_path = 'cookbooks'
      chef.nodes_path = 'fixtures/nodes'
      chef.json = {
        iptables_web: {
          server: {
            repo: 'file:////iptables_web_repo',
            force_ssl: true,
            listen: ['80', '443 ssl'],
            ssl_certificate: '/etc/ssl/certs/ssl-cert-snakeoil.pem',
            ssl_key: '/etc/ssl/private/ssl-cert-snakeoil.key',
            fqdn: 'iptables-server.dev',
            google: {
              key: ENV['IPTABLES_WEB_GKEY'],
              secret: ENV['IPTABLES_WEB_GSECRET'],
              domains: %w(iptables-server.dev)
            }
          }
        }
      }
      chef.log_level = :debug
      chef.run_list = [
        'iptables_web::server_mysql_service',
        'iptables_web::server'
      ]
    end
  end

  config.vm.define "client" do |es|
    es.vm.hostname = 'iptables-client'
    es.vm.network :private_network, ip: '35.35.35.32'
    es.hostmanager.aliases = %w(iptables-client.dev) if Vagrant.has_plugin?('vagrant-hostmanager')
    es.vm.provision :chef_zero do |chef|
      # puts attrs
      chef.log_level = :debug
      chef.cookbooks_path = 'cookbooks'
      chef.nodes_path = 'fixtures/nodes'
      chef.json = {
        'build-essential' => {
          compile_time: true,
        },
        iptables_web: {
          client: {

          }
        }
      }
      chef.run_list = [
        'iptables_web::client',
        'iptables_web::client_register',
        'iptables_web::client_configuration'
      ]
    end
  end
end
