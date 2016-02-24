class profile::iis {

  windowsfeature { 'IIS':
    feature_name => [
      'Web-Server',
      'Web-WebServer',
      'Web-Mgmt-Console',
      'Web-Mgmt-Tools'
    ]
  }
}
