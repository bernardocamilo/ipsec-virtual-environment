# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use Official Ubuntu Server 14.04 LTS (Trusty Tahr) build
  config.vm.box = "ubuntu/trusty64"

  # Gateway hosts
  ['moon.gateway', 'sun.gateway'].each_with_index do |machine, index|
    config.vm.define machine do |gateway_config|
      gateway_config.vm.hostname = machine
      gateway_config.vm.network :private_network,
                                :ip => "10.#{index + 1}.0.1",
                                :netmask => "255.255.0.0",
                                virtualbox__intnet: true
      gateway_config.vm.network :private_network,
                                :ip => "192.168.0.#{index +1}",
                                :netmask => "255.255.255.0",
                                virtualbox__intnet: true
      gateway_config.vm.provision "puppet" do |puppet|
        puppet.manifest_file = "gateway.pp"
      end
    end
  end

  # Client hosts
  ['alice.client', 'bob.client'].each_with_index do |machine, index|
    config.vm.define machine do |client_config|
      client_config.vm.hostname = machine
      client_config.vm.network :private_network,
                               :ip => "10.#{index +1}.0.10",
                               :netmask => "255.255.0.0",
                               virtualbox__intnet: true
      client_config.vm.provision "puppet" do |puppet|
        puppet.manifest_file = "client.pp"
      end
    end
  end
end

