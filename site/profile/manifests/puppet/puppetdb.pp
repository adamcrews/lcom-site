class profile::puppet::puppetdb {

  class { 'puppetdb': 
    disable_ssl => true,
  }
  class { 'puppetdb::master::config': 
    puppetdb_disable_ssl => true,
  }

}
