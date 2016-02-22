# Setup a puppetserver and enforce java settings
class profile::puppet::server {

  class { '::puppetserver::repository': } ->
  class { '::puppetserver':
    config => {
      'java_args'     => {
        'xms'         => '4g',
        'xmx'         => '6g',
        'maxpermsize' => '512m',
      },
    },
  }
}
