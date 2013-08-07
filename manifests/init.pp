# == Class: opennetadmin
#
# Download, Install, Configure OpenNetAdmin
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
class opennetadmin (
  $version        = 'current',
  $install_dir    = '/opt/ona',
  $install_url    = 'http://github.com/opennetadmin/ona/archive',
  $default_domain = 'localhost',
  $auto_setup     = false,
  $enable_nmap    = false,
  $nmap_all_nets  = false,
  $admin_user     = 'admin',
  $admin_password = 'admin',
  $db_name        = 'ona_default',
  $db_host        = 'localhost',
  $db_user        = 'ona_sys',
  $db_password    = 'password',
  $ona_owner      = 'root',
  $ona_group      = '0',
  $ona_url        = 'http://localhost/ona',
  $include_dcm    = true,
  $dcm_install_url = 'https://raw.github.com/opennetadmin/dcm/master',
  $dcm_log_file   = '/var/log/dcm.log'
) {

  class { 'opennetadmin::app':
    version         => $version,
    install_dir     => $install_dir,
    install_url     => $install_url,
    ona_owner       => $ona_owner,
    ona_group       => $ona_group,
  }

  # Web App manages files in this directory.
  file { "${install_dir}/www/local":
    owner   => $ona_owner,
    group   => $ona_group,
    mode    => '0644',
    recurse => true,
  }

  ## Log File
  file { '/var/log/ona.log':
    ensure  => file,
    owner   => $ona_owner,
    group   => $ona_group,
    mode    => '0644',
  }

  if $auto_setup {
    class { 'opennetadmin::app::setup':
      ona_directory   => $install_dir,
      default_domain  => $default_domain,
      db_name         => $db_name,
      db_user         => $db_user,
      db_password     => $db_password,
      admin_user      => $admin_user,
      admin_password  => $admin_password,
    }
    Class['opennetadmin::app'] -> Class['opennetadmin::app::setup']
  }

  if $include_dcm {
    class { 'opennetadmin::app::dcm':
      ona_directory  => $install_dir,
      ona_owner      => $ona_owner,
      ona_group      => $ona_group,
      ona_url        => $ona_url,
      install_url    => $dcm_install_url,
      log_file       => $dcm_log_file,
    }
    Class['opennetadmin::app'] -> Class['opennetadmin::app::dcm']
  }

  if $enable_nmap {
    Class['opennetadmin::app'] -> class { 'opennetadmin::app::nmap_plugin': all_subnets => $nmap_all_nets }
  }


}
