class profile::base {
  include profile::puppet::agent
  include awscli
  class { 'ec2tagfacts': }
}
