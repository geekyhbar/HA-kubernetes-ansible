#! /bin/bash
set -x

[[ $(basename $(pwd)) == "HA-kubernetes-ansible" ]] || \
[[ -d ~/github/HA-kubernetes-ansible ]] && \
cd ~/github/HA-kubernetes-ansible && \
vagrant halt master1 && vagrant destroy master1 && \
vagrant halt master2 && vagrant destroy master2 && \
vagrant halt node1 && vagrant destroy node1 && \
vagrant halt node2 && vagrant destroy node2 && \
[[ -d ~/.vagrant.d ]] && rm -rf ¯/.vagrant.d && \
[[ -d .vagrant ]] && rm -rf .vagrant && \
vagrant plugin install vagrant-libvirt && \
vagrant up && \
cp ~/.ssh/config ~/.ssh/config.orig && \
cp ~/.ssh/id_rsa.pub ssh-key.pub && \
for a in master1 master2 node1 node2; do vagrant ssh-config ${a} >> ~/.ssh/config; done && \
for a in master1 master2 node1 node2; do ssh ${a} exit; done && \
#for a in 11 12 21 22; do ssh 192.168.50.${a} exit; done && \
ansible all -i vagrant -m setup --tree facts -a 'gather_timeout=30'
ansible-playbook -i vagrant -b -u vagrant cluster.yml
#ansible-playbook -i vagrant -b -u vagrant addon.yml
# TODO: move to Vagrantfile once it works reliably
