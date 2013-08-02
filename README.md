puppet-opennetadmin
==========
opennetadmin

This module downloads, installs, and configures Open Net Admin

The base class 'opennetadmin' can setup everything including DCM and the nmap
plugin. Any additional plugins can be declared as an opennetadmin::app::plugin
resource.

This module only manages Open Net Admin and plugins. Configuration of database
and web server is beyond the scope of this module.

Parameters
----
[*version*]
 Optional. The version of Open Net Admin to install.
 Default: 'current'; any other value also requires $install_url.

[*install_dir*]
  Optional. Location to install Open Net Admin.
  Default: '/opt/ona'.

[*install_url*]
  OPtional. URL to use to download application files.
  Default: 'http://github.com/opennetadmin/ona/archive'

[*ona_owner*]
  Recomended. The system account which will own the ONA application files.
  Default: 'root'

[*ona_group*]
  Recomended. The system group ID which will own the ONA application files.
  Default: '0'

[*auto_setup*]
  Optional. If true, try to configure the application automatically by building
  the database settings file and using curl to post parameters to the install
  script.
  Default: false

[*default_domain*]
  Recomended when $auto_setup is true. The name of the default domain used when
  performing automatic setup.
  Default: 'localhost'; which probably isn't valid.

[*admin_user*]
  Optional when $auto_setup is true. The name of the initial administrator account.
  Default: 'admin'

[*admin_password*]
  Optional when $auto_setup is true. The password for the initial administrator account.
  Default: 'admin'

[*db_name*]
  Optional when $auto_setup is true. The name of the database that ONA will use.
  Default: 'ona_default'

[*db_host*]
  Optional when $auto_setup is true. The name of the database server.
  Default: 'localhost'

[*db_user*]
  Optional when $auto_setup is true. The name ONA will use to connect to the database.
  Default: 'ona_sys'

[*db_password*]
  Recomended when $auto_setup is true. The password ONA will use to connect to the database.
  Default: 'password'

[*include_dcm*]
  Optional. If true, download and install DCM.
  Default: true

[*dcm_install_url*]
  Optional when $include_dcm is true. Download location of the DCM install files.
  Default: 'https://raw.github.com/opennetadmin/dcm/master'

[*dcm_log_file*]
  Optional when $include_dcm is true. Location of the DCM log file.
  Default: '/var/log/dcm.log'

[*ona_url*]
  Optional when $include_dcm is true. Where DCM will look for dcm.php.
  Default: 'http://localhost/ona'

[*enable_nmap*]
  Optional. If true, install and configure the pre-packaged ona_nmap_scans plugin.
  Default: false

[*nmap_all_nets*]
  Optional when $enable_nmap is true. Configure the cron job to scan all subnets
  that are not specifically configured.
  Default: false

Example
----
    class { 'opennetadmin':
      default_domain => 'mydomain.com',
      auto_setup     => false,
      enable_nmap    => true,
      nmap_all_nets  => true,
      admin_password => 'secret',
      db_password    => 'db-secret',
      ona_owner      => 'www-data',
      ona_group      => 'www-data',
      include_dcm    => true,
    }

    'opennetadmin::app::plugin' { 'build_bind': ensure => 'installed'}

Heira Example
----

    ---
    classes: -'opennetadmin'
    opennetadmin::default_domain: 'mydomain.com'
    opennetadmin::auto_setup:     'false'
    opennetadmin::enable_nmap:    'true'
    opennetadmin::nmap_all_nets:  'true'
    opennetadmin::admin_password: 'secret'
    opennetadmin::db_password:    'db-secret'
    opennetadmin::ona_owner:      'www-data'
    opennetadmin::ona_group:      'www-data'
    opennetadmin::include_dcm:    'true'

