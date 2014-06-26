# Create a custom installation processs for opennetadmin
# Sets the lest required installation parameters and spawn the installation process.
#
# Defaults come from the parent opennetadmin class.
#
# [*ona_directory*]
#
# [*ona_domain*]
#
# [*db_name*]
#
# [*db_user*]
#
# [*db_password*]
#
#
class opennetadmin::app::setup (
  $admin_user     = 'admin',
  $admin_password = 'admin',
  $ona_directory  = $opennetadmin::ona_directory,
  $default_domain = $opennetadmin::default_domain,
  $db_host        = $opennetadmin::db_host,
  $db_name        = $opennetadmin::db_name,
  $db_user        = $opennetadmin::db_user,
  $db_password    = $opennetadmin::db_password,
) {
  include 'opennetadmin::params'

  # Setup database config file
  file { "${ona_directory}/www/local/config/database_settings.inc.php":
    ensure  => file,
    mode    => '0644',
    content => template('opennetadmin/database_settings.inc.php.erb'),
  }

  if !defined(Package[$opennetadmin::params::curl_package]) {
    package { $opennetadmin::params::curl_package: ensure => present }
  }

  # curl to initiate the installation
  $post_values_1 = "&overwrite=N&keep=N&database_host=${db_host}&dbtype=mysqlt&database_name=${db_name}&default_domain=${default_domain}&"
  $post_values_2 = "admin_login=${admin_user}&admin_passwd=${admin_password}&sys_login=${db_user}&sys_passwd=${db_password}"
  $post_page = 'http://localhost/?install_submit=Y'
  exec { 'opennetadmin-auto-install':
    command     => "curl -d \'${post_values_1}${post_values_2}\' ${post_page}",
    require     => [Package[$opennetadmin::params::curl_package],Service['httpd']],
    refreshonly => true,
    logoutput   => true,
    subscribe   => File["${ona_directory}/www/local/config/database_settings.inc.php"],
  }
}
