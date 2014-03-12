# == Class: opennetadmin::app
#
# OpenNetAdmin Application Installation
# Should be called from Class['opennetadmin'] which will populate params.
#
# https://github.com/opennetadmin/ona/wiki/Install
#
# NOTE: This manifest assumes that the tar command is already installed.
#       It will install wget if necessary.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Atom Powers <atom.powers@seattlebiomed.org>
#
# === Copyright
#
# Copyright 2013 Seattle Biomedical, unless otherwise noted.
#
class opennetadmin::app (
  $version      = 'current',
  $install_dir  = '/opt/ona',
  $install_url  = 'http://github.com/opennetadmin/ona/archive',
  $ona_owner    = 'root',
  $ona_group    = '0'
) {
  include 'opennetadmin::params'

  ## Resource defaults
  File {
    owner  => $ona_owner,
    group  => $ona_group,
    mode   => '0644',
  }

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $install_dir,
    user      => $ona_owner,
    group     => $ona_group,
  }

  ensure_resource ( package, $opennetadmin::params::wget_package, { ensure => 'installed' } )

  ## Installation directory
  file { $install_dir:
    ensure  => directory,
    recurse => true,
  }

  ## opennetadmin Tarball
  if $version == 'current' {
    $download = 'ona-current.tar.gz'
  } else {
    $download = "ona-${version}.tar.gz"
  }

  ## Download and extract; specific version or latest.
  exec { 'download-opennetadmin-pkg':
    command => "wget -O ${install_dir}/${download} -nc ${install_url}/${download}",
    creates => "${install_dir}/${download}",
    require => File[$install_dir],
  }
  -> exec { 'extract-opennetadmin-pkg':
    command => "tar -C ${install_dir} -zxf ${download} --strip-components=1",
    creates => "${install_dir}/www/index.php",
  }
  -> file { '/etc/onabase': content => "${install_dir}\n" }

  # Requeired PHP libraries
  if !defined(Package['php5-gmp']) {
    package{'php5-gmp': ensure=>'installed' }
  }

}
