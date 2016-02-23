filebucket { 'main':
  server => $::servername,
  path   => false,
}

File { backup => 'main' }

Package {
  allow_virtual => true,
}

case $::kernel {
  'windows': { Package { provider => chocolatey, } }
}

