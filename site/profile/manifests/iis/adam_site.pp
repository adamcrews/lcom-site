class profile::iis::adam_site (
  
) inherits profile::iis {

  ensure_packages(['git'])

  iis::manage_app_pool {'adam_application_pool':
    enable_32_bit           => true,
    managed_runtime_version => 'v4.0',
  }

  iis::manage_site {'foo.ldc.poc':
    site_path     => 'C:\inetpub\wwwroot\foo.ldc.poc',
    port          => '80',
    ip_address    => '*',
    host_header   => 'foo.ldc.poc',
    app_pool      => 'adam_application_pool',
  }
}
