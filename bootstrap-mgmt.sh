#!/usr/bin/env bash

# install ansible (http://docs.ansible.com/intro_installation.html)
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible
ansible-galaxy install geerlingguy.mysql
ansible-galaxy install Stouts.mongodb
ansible-galaxy install geerlingguy.redis
ansible-galaxy install Stouts.rabbitmq
ansible-galaxy install geerlingguy.memcached
ansible-galaxy install geerlingguy.composer
ansible-galaxy install geerlingguy.php
ansible-galaxy install geerlingguy.apache
ansible-galaxy install geerlingguy.git
ansible-galaxy install geerlingguy.php-mysql
ansible-galaxy install geerlingguy.solr
ansible-galaxy install geerlingguy.varnish
ansible-galaxy install geerlingguy.php-memcached
ansible-galaxy install arknoll.selenium
ansible-galaxy install geerlingguy.php-redis
ansible-galaxy install geerlingguy.php-xdebug
ansible-galaxy install geerlingguy.blackfire
ansible-galaxy install geerlingguy.elasticsearch
ansible-galaxy install geerlingguy.elasticsearch-curator
ansible-galaxy install geerlingguy.jenkins
ansible-galaxy install geerlingguy.memcached
ansible-galaxy install geerlingguy.munin-node
ansible-galaxy install geerlingguy.nfs
ansible-galaxy install geerlingguy.pimpmylog
ansible-galaxy install geerlingguy.haproxy
ansible-galaxy install geerlingguy.sonar
ansible-galaxy install geerlingguy.sonar-runner
ansible-galaxy install telusdigital.newrelic
ansible-galaxy install hswong3i.bitbucket

# copy examples into /home/vagrant (from inside the mgmt node)
cp -a /vagrant/files/* /home/vagrant
chown -R vagrant:vagrant /home/vagrant
#chmod -R 744 /home/vagrant/files/*.sh

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.10  mgmt
10.0.15.11  lb
10.0.15.20  dev
10.0.15.21  rdb1
10.0.15.22  cdb
10.0.15.23  deploy
10.0.15.24  prod1
10.0.15.25  prod2
10.0.15.26  prod3
10.0.15.27  varnish
EOL

ssh-keygen -t rsa -b 2048
ssh-keyscan dev rdb1 cdb mgmt deploy >> .ssh/known_hosts
ansible all -m ping --ask-pass

#ansible-playbook -s add_key.yml --ask-pass
#ansible-playbook -s deploy
#ansible-playbook -s rdb
#ansible-playbook -s cdb
#ansible-playbook -s web
