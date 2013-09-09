# Install DCM.pl command line interface for OpenNetAdmin
#
# https://github.com/opennetadmin/dcm
#
class opennetadmin::app::dcm (
  $ona_directory  = $opennetadmin::install_dir,
  $ona_url        = 'http://localhost/ona',
  $install_url    = 'https://raw.github.com/opennetadmin/dcm/master',
  $ona_owner      = $opennetadmin::ona_owner,
  $ona_group      = $opennetadmin::ona_group,
  $log_file       = '/var/log/dcm.log'
  $admin_user     = $opennetadmin::admin_user,
  $admin_password = $opennetadmin::admin_password
) {
  include 'opennetadmin::params'

  $dcm_url     = "${ona_url}/dcm.php"

  ## Resource defaults
  File {
    owner  => $ona_owner,
    group  => $ona_group,
    mode   => '0644',
  }

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $ona_directory,
    user      => $ona_owner,
    group     => $ona_group,
  }

  if !defined(Package[$opennetadmin::params::wget_package]) {
    package { $opennetadmin::params::wget_package : ensure => 'present' }
  }

  ## Log File
  file { $log_file:
    ensure  => file,
    owner   => $ona_owner,
    group   => $ona_group,
    mode    => '0664',
  }

  ## Configuration file
  file {"${ona_directory}/etc/dcm.conf":
    ensure  => 'present',
    content => template('opennetadmin/dcm.conf.erb'),
    require => File[$ona_directory],
  }

  ## Download.
  exec { 'download-opennetadmin-dcm-pl':
    command => "wget -O ${ona_directory}/bin/dcm.pl -nc ${install_url}/dcm.pl",
    creates => "${ona_directory}/bin/dcm.pl",
    require => File[$ona_directory],
  }
  -> file { "${ona_directory}/bin/dcm.pl": mode => '0555' }
  -> file { '/usr/local/bin/dcm.pl':
    ensure  => link,
    target  => "${ona_directory}/bin/dcm.pl",
  }

}
