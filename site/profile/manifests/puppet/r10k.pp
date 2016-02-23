# Configure r10k with zack/r10k module
class profile::puppet::r10k {
  $remote = hiera('r10k::remote')
  $include_prerun = hiera('r10k::include_prerun_command', true)

  class { '::r10k':
    remote                 => $remote,
    include_prerun_command => $include_prerun,
    cachedir               => '/opt/puppetlabs/puppet/cache/r10k'
  }

  #  include ::r10k::webhook

}
