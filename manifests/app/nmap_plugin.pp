# Install the nmap plugin, which is packaged with OpenNetAdmin
#
#
class opennetadmin::app::nmap_plugin (
  $all_subnets   = false,
  $update_time   = false,
  $ona_owner     = $opennetadmin::ona_owner,
  $ona_group     = $opennetadmin::ona_group,
  $install_dir   = $opennetadmin::install_dir
) {
  include 'opennetadmin::app::dcm'

  $plugin_dir     = "${install_dir}/www/local/plugins"

  $cron_all = $all_subnets ? {
    true    => '-a',
    default => '',
  }

  $cron_update = $update_time ? {
    true    => '-u',
    default => '',
  }

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $plugin_dir,
    user      => $ona_owner,
    group     => $ona_group,
  }

  File {
    owner     => $ona_owner,
    group     => $ona_group,
    mode      => '0644'
  }

  file { "${plugin_dir}":
    ensure    => directory,
  }

  file { "${plugin_dir}/ona_nmap_scans":
    ensure    => directory,
  }
  file { "${plugin_dir}/ona_nmap_scans/subnets":
    ensure    => directory,
  }
  -> file { "${plugin_dir}/ona_nmap_scans/subnets/nmap.xsl":
    ensure  => link,
    target  => "${install_dir}/www/plugins/ona_nmap_scans/nmap.xsl"
  }

  file { "${install_dir}/www/plugins/ona_nmap_scans/nmap_scan_cron":
    mode => '0555'
  }
  -> file { "${install_dir}/bin/nmap_scan_cron":
    ensure  => link,
    target  => "${install_dir}/www/plugins/ona_nmap_scans/nmap_scan_cron"
  }
  -> cron { 'nmap_scan_cron':
    command => "${install_dir}/bin/nmap_scan_cron ${cron_all} ${cron_update}",
    user    => $ona_owner,
    hour    => '3',
    minute  => '33'
  }
}
