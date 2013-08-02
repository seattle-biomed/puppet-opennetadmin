# Default Parameters for Wordpress
#
class opennetadmin::params {
  $wget_package = $::osfamily ? {
    'Debian'  => 'wget',
    'RedHat'  => 'wget',
    default   => 'wget',
  }
  $curl_package = $::osfamily ? {
    'Debian'  => 'curl',
    'RedHat'  => 'curl',
    default   => 'curl',
  }
  $unzip_package = $::osfamily ? {
    'Debian'  => 'unzip',
    'RedHat'  => 'unzip',
    default   => 'unzip',
  }

}
