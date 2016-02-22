# this file is for negotiating sensible
# defaults for your profile::puppet::*
# classes. This makes your code less messy
# and follows puppet best practices.
class profile::puppet::params {
  $confdir = "/etc/puppetlabs/code"
  $hieradir = "${confdir}/environments/%{::environment}/hieradata"
  $environmentpath = "${confdir}/environments"
}
