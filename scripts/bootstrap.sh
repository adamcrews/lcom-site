#!/bin/bash -xv

# This script will bootstrap puppet hosts
#

while getopts ":r:k:" opt; do
  case $opt in
    r)
      ROLE=$OPTARG
    ;;
    k)
      R10k_REMOTE=$OPTARG
    ;;
   \?)
     echo "Invalid option -$OPTARG"
     exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument."
    exit 1
   ;;
  esac
done


if [ -f /etc/os-release ]; then
  . /etc/os-release
  VER_LABEL=`echo $VERSION | sed -e 's/[^a-z]//g'`
else
  echo "OS too old... get a newer one"
  exit 1
fi

repo_install () {
  case $ID in
    'centos')
      yum install -y https://yum.puppetlabs.com/puppetlabs-release-el-$RELEASE_ID.noarch.rpm
      yum clean metadata -y
      ;;
    'debian')
      URL="https://apt.puppetlabs.com/puppetlabs-release-pc1-$VER_LABEL.deb"; FILE=`mktemp`; wget "$URL" -qO $FILE && DEBIAN_FRONTEND=noninteractive dpkg -i $FILE; rm $FILE
      DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update
      ;;
    *)
      echo "Unknown OS, try again"
      exit 1
      ;;
  esac
}

install_pkg() {
  case $ID in
    'centos')
      yum install -y $1
      ;;
    'debian')
      DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install $1
      ;;
    *)
      echo "Still an unknown os..."
      exit 1
      ;;
  esac
}

install_puppet_module() {
  /opt/puppetlabs/bin/puppet module install $1
}

install_master() {
  install_pkg puppetserver
  install_puppet_module 'zack/r10k'

  # Generate our master certs
  puppet config set --section main dns_alt_names = puppet,puppet.$(facter domain),$(facter hostname),$(facter fqdn)
  rm -rf $(puppet config print ssldir) 
  (cmdpid=$BASHPID; (sleep 20; kill $cmdpid) & exec puppet master --no-daemonize --verbose )

  # Egg, meet Chicken.
  # We need puppet configured properly so it can configure r10k, but
  # we need r10k configured properly so puppet can be configured.
  echo "class { '::r10k': remote => \"${R10k_REMOTE}\" }" > /tmp/r10k.pp
  /opt/puppetlabs/bin/puppet apply /tmp/r10k.pp
  r10k deploy environment -p -v

  # Apply the master profile(s)
  /opt/puppetlabs/bin/puppet apply -e 'include ::profile::puppet::hiera'
  /opt/puppetlabs/bin/puppet apply -e 'include ::role::puppet::master'

}

install_agent() {
  :
}

####################################################################
## Finally let's do stuff
##
repo_install
install_pkg git

case $ROLE in
  'master')
    install_master
    ;;
  *)
    install_agent
    ;;
esac
