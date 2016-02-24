class profile::base {
  include profile::puppet::agent
  class { 'ec2tagfacts': }
}
