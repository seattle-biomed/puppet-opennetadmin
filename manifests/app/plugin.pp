# Defined Resource for installing plugins
#
# The Puppet DSL makes it difficult to cut up a URI into file and URL.
#
# Some of the download process, the rename, assume the plugin is coming from github.
#
# [*name*] - The simple name of the plugin, as known to opennetadmin
# [*download_file*] - The name of the plugin file to download.
# [*download_url*] - The URL of the plugin file to download.
#
define opennetadmin::app::plugin (
  $download_url   = undef,
  $ensure         = 'present',
  $install_dir    = $opennetadmin::install_dir
  $ona_owner      = $opennetadmin::ona_owner,
  $ona_group      = $opennetadmin::ona_group,
) inherits opennetadmin::params {

  $plugin_dir     = "${install_dir}/www/local/plugins"

  # Default download location.
  if !defined($download_url) {
    $download_url   = "https://github.com/opennetadmin/${name}/archive/master.zip"
  }
  $download_file  = "${name}.zip"

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $plugin_dir,
    user      => $ona_owner,
    group     => $ona_group,
  }

  if ( $ensure == 'absent' ) {

    file { "${plugin_dir}/${name}" : ensure => absent }

  } else {

    include opennetadmin::params
    $unzip_package = $opennetadmin::params::unzip_package

    if !defined(Package[$unzip_package]) {
      package { $unzip_package : ensure => 'present' }
    }

    # Download and Extract
    exec { "download-opennetadmin-plugin-${name}":
      command => "wget -nc ${download_url} -O ${plugin_dir}/${download_file}",
      creates => "${plugin_dir}/${download_file}",
      require => Exec['extract-opennetadmin-pkg'],
    }
    -> exec { "extract-opennetadmin-plugin-${name}":
      command => "unzip ${download_file}",
      creates => "${plugin_dir}/${name}",
      require => Package[$unzip_package],
    }


    # Installation and configuration is left to the opennetadmin GUI

  }
}
