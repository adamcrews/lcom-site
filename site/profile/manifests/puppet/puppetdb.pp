class profile::puppet::puppetdb {

  class { 'puppetdb': }
  class { 'puppetdb::master::config': 
    manage_report_processor => true,
  }

}
