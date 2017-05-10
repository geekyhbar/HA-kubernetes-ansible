# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

SSH_PUB_KEY = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip

$script = <<SCRIPT
echo #{SSH_PUB_KEY} >> /home/$USER/.ssh/authorized_keys
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "nrclark/xenial64-minimal-libvirt"

	config.vm.provider "libvirt" do |v|
		# avoid domain name conflicts
		v.random_hostname = true

		# TBD: make these customizable
		v.memory = 4096
		v.cpus = 2
		v.storage :file, :size => '20G'

		# Another possibility for bigger VM disk
		# (harder to deal with when using Ansible LVM modules)
		# v.machine_virtual_size = 40

		v.nested = true
		v.volume_cache = 'none'
	end

	config.vm.box_check_update = false
	
	config.vm.define "master1" do |node|
		node.vm.network "private_network", ip: "192.168.50.11"
		node.vm.hostname = "master1"

		# provision one liner below doesn't work because of:
		#==> master2: mesg: 
		#==> master2: ttyname failed
		#==> master2: : 
		#==> master2: Inappropriate ioctl for device		
		#node.vm.provision :shell, inline: "cat ssh-key.pub >> .ssh/authorized_keys"

		config.ssh.forward_agent    = true
		config.ssh.insert_key       = false
		config.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","~/.ssh/id_rsa"]
		config.vm.provision :shell, :privileged => false, :inline => "$script"
	end

	config.vm.define "master2" do |node|
		node.vm.network "private_network", ip: "192.168.50.12"
		node.vm.hostname = "master2"
		
		#node.vm.provision :shell, inline: "cat ssh-key.pub >> .ssh/authorized_keys"

		config.ssh.forward_agent    = true
		config.ssh.insert_key       = false
		config.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","~/.ssh/id_rsa"]
		config.vm.provision :shell, :privileged => false, :inline => "$script"
	end

	config.vm.define "node1" do |node|
		node.vm.network "private_network", ip: "192.168.50.21"
		node.vm.hostname = "node1"
		
		#node.vm.provision :shell, inline: "cat ssh-key.pub >> .ssh/authorized_keys"

		config.ssh.forward_agent    = true
		config.ssh.insert_key       = false
		config.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","~/.ssh/id_rsa"]
		config.vm.provision :shell, :privileged => false, :inline => "$script"
	end

	config.vm.define "node2" do |node|
		node.vm.network "private_network", ip: "192.168.50.22"
		node.vm.hostname = "node2"
		
		#node.vm.provision :shell, inline: "cat ssh-key.pub >> .ssh/authorized_keys"

		config.ssh.forward_agent    = true
		config.ssh.insert_key       = false
		config.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","~/.ssh/id_rsa"]
		config.vm.provision :shell, :privileged => false, :inline => "$script"
	end

	# see
	# http://stackoverflow.com/questions/20952689/ansible-ssh-forwarding-doesnt-seem-to-work-with-vagrant
	# for details
	#config.vm.provision "ansible" do |ansible|
	#	ansible.playbook = "cluster.yml"
	#	ansible.sudo = true
	#	ansible.host_key_checking = false
	#	ansible.verbose =  'vvvv'
	#	ansible.extra_vars = { ansible_ssh_user: 'vagrant', 
	#		ansible_connection: 'ssh',
	#		ansible_ssh_args: '-o ForwardAgent=yes'}
	#	ansible.raw_ssh_args = ['-o UserKnownHostsFile=/dev/null']
	#end

	#config.ssh.forward_agent = true

	#config.vm.define "yum-proxy" do |node|
	#	node.vm.network "private_network", ip: "192.168.50.99"
	#	node.vm.hostname = "cache"
		
	#	node.vm.provision :shell, inline: "cat ssh-key.pub >> .ssh/authorized_keys"
	#end
end
