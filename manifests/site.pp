filebucket { 'main':
  server => $::servername,
  path   => false,
}

File { backup => 'main' }

Package {
  allow_virtual => true,
}

node /vagrant-master/ {
  include ::role::puppet::master
}

#node default {
#
#}
