class profile::puppet::hiera (
    $hiera_eyaml = false,
) inherits ::profile::puppet::params {
  validate_bool($hiera_eyaml)

  File {
    owner => 'root',
    group => 'root',
  }

  class { 'hiera':
    hierarchy => [
      'nodes/%{clientcert}',
      'app_tier/%{app_tier}',
      'env/%{environment}',
      'common',
    ],
    datadir   => $profile::puppet::params::hieradir,
    backends  => $backends,
    notify    => Service['puppetserver'],
  }

}
