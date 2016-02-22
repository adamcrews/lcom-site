# This class will do all the things needed to become
# a proper puppetmaster.
class role::puppet::master {
  include ::profile::base
  include ::profile::puppet::server
  include ::profile::puppet::hiera
  include ::profile::puppet::r10k
  include ::profile::puppet::puppetdb
}
