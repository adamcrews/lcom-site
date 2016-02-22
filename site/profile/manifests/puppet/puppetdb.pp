class profile::puppet::puppetdb {

  class { 'puppetdb': }
  class { 'puppetdb::master::config': }

}
