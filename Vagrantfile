# -*- mode: ruby -*-
# vi: set ft=ruby :

localuser = Etc.getpwuid(Process.euid).name
my_repo = `git remote -v`.split[1]

Vagrant.configure(2) do |config|

  nodes = {
    :master => { :role => 'master' },
    :linux => { :role => 'base' },
    :centos => { :role => 'base', :os => 'centos', :box => 'bento/centos-7.2'},
    :fail => { :role => 'base', :os => 'windows' }
  }
  
  nodes.each do |n, settings|
    role = settings[:role]
    os = settings[:os] || 'debian'
    box = settings[:box] || 'debian/jessie64'

    config.vm.boot_timeout = 500

    config.vm.define n do |node|
      node.vm.provider :virtualbox do |vb|
        vb.customize [ "modifyvm", :id, "--memory", "4096"]
        vb.customize [ "modifyvm", :id, "--cpus", "4"]
        vb.customize [ "modifyvm", :id, "--ioapic", "on"]
        if os == 'windows'
          vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
        end
      end

      if os == 'windows'
        node.vm.box = "ferventcoder/win7pro-x64-nocm-lite"
        #node.vm.hostname = "vagrant-#{role}-#{localuser}"
        node.vm.hostname = "vagrant-#{role}"
        node.vm.network :private_network, :auto_network => true
        node.vm.network "forwarded_port", guest: 22, host: 2200, id: "ssh", auto_correct: true
        node.vm.network "forwarded_port", guest: 3389, host: 3389, id: "rdp", auto_correct: true
        node.vm.network "forwarded_port", guest: 5985, host: 5985, id: "winrm", auto_correct: true
        node.windows.set_work_network = true
#        node.vm.provision 'shell', path: "bootstrap/Install-Puppet.ps1", args: [ puppetversion, puppetmaster ]
      else
        node.vm.box = box
        #node.vm.hostname = "vagrant-#{role}-#{localuser}"
        node.vm.hostname = "vagrant-#{role}"
        node.vm.network :private_network, :auto_network => true
        node.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
        node.vm.network "forwarded_port", guest: 8090, host: 8090, auto_correct: true
        node.vm.provision 'shell', path: 'scripts/bootstrap.sh', args: [ '-r', role, '-k', my_repo ]
      end
    end
  end
end



