# DevOps Local Lab using Vagrant + VirtualBox
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"   # Ubuntu 22.04 LTS

  # Default settings for all VMs
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Main DevOps host (for CLI / Docker labs)
  config.vm.define "devops-master" do |master|
    master.vm.hostname = "devops-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      apt-get install -y git curl vim jq htop net-tools unzip wget python3-pip
      apt-get install -y docker.io docker-compose
      usermod -aG docker vagrant
    SHELL
  end

  # Optional: second VM for SSH / Ansible practice
  config.vm.define "devops-node1" do |node|
    node.vm.hostname = "devops-node1"
    node.vm.network "private_network", ip: "192.168.56.11"
    node.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      apt-get install -y python3
    SHELL
  end
end
