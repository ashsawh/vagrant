# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = configs['configs'][configs['configs']['use']] 
ansible_config = vagrant_config['ansible_mgmt'] 
mgmt_ip = vagrant_config['base_ip'] + '.10'
boxes = vagrant_config['boxes']

Vagrant.configure(2) do |config|
  (0..boxes.count-1).each do |i|
    box_ip = "#{vagrant_config['base_ip']}.2#{i}"
    box = boxes.keys[i]
    os = boxes.values[i]
    config.vm.define box do |node|
        node.vm.box = os
        node.vm.hostname = box
        node.vm.network :private_network, ip: box_ip
        node.vm.network "forwarded_port", guest: 80, host: "418#{i}"
        node.vm.provider vagrant_config['provider'] do |vb|
          vb.memory = "1024"
        end
    end
  end

  # create mgmt node
  config.vm.define :mgmt do |mgmt_config|
      mgmt_config.vm.box = ansible_config['os']
      mgmt_config.vm.hostname = "mgmt"
      mgmt_config.vm.network :private_network, ip: mgmt_ip
      mgmt_config.vm.provider vagrant_config['provider'] do |vb|
        vb.memory = "512"
      end
      mgmt_config.vm.provision :shell, path: "bootstrap-mgmt.sh"
  end
end