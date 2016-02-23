class role::iistest {
  include ::profile::base
  include ::profile::chocolatey
  include ::profile::iis::adam_site
}
