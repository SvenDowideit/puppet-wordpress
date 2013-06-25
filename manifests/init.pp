# == Class: wordpress
#
# This module manages wordpress configuration files and plugins.
#
# Database and web service management is left to other modules.
#
# === Parameters
#
# [*install_dir*]
#   Specifies the directory into which wordpress should be installed. Default:
#   /opt/wordpress
#
# [*install_url*]
#   Specifies the url from which the wordpress tarball should be downloaded.
#   Default: http://wordpress.org
#
# [*version*]
#   Specifies the version of wordpress to install. Default: 3.5
#
# [*db_name*]
#   Specifies the database name which the wordpress module should be configured
#   to use. Default: wordpress
#
# [*db_host*]
#   Specifies the database host to connect to. Default: localhost
#
# [*db_user*]
#   Specifies the database user. Default: wordpress
#
# [*db_password*]
#   Specifies the database user's password in plaintext. Default: password
#
# [*wp_owner*]
#   Specifies the owner of the wordpress files. Default: root
#
# [*wp_group*]
#   Specifies the group of the wordpress files. Default: 0 (*BSD/Darwin
#   compatible GID)
#
# [*wp_lang*]
#   WordPress Localized Language. Default: ''
#
# [*wp_plugin_dir*]
#   WordPress Plugin Directory. Full path, no trailing slash. Default: WordPress Default
#
# [*wp_allow_multisite*]
#  Enable MultiSite mode. Default: `false`
#
# [*auto_setup*]
#  Automatically setup the local admin user; automates the "Famous 5-Minute Setup". Default: `false`
#
# [*site_name*]
#  The name of the wordpress site. Default: `WordPress`
#
# [*site_admin*]
#  The name of the local admin user. Default: `admin`
#
# [*admin_pwd*]
#  The password for the admin user. If not given WordPress will generate one
#  and it isn't captured, so this option is strongly recomended. Default: ``
#
# [*admin_mail*]
#  The email address for the admin user. If not specified the automatic setup
#  will fail.
#
## Example Usage
#---------------
#
#class { 'wordpress':
#  install_dir    => '/var/www/myblog',
#  plugin_dir     => '/var/www/myblog/plugins',
#  version        => '3.5',
#  db_name        => 'wpdb',
#  db_host        => 'mysql.my.domain',
#  db_user        => 'wordpressdb',
#  db_password    => 'password',
#  auto_setup     => true,
#  site_name      => 'My Blog',
#  site_admin     => 'admin',
#  admin_pwd      => 'secret',
#  admin_mail     => 'webmaster@my.domain',
#  wp_owner       => 'www-data',
#  wp_group       => '33',
#}
#
class wordpress (
  $version        = 'latest',
  $install_dir    = '/opt/wordpress',
  $install_url    = 'http://wordpress.org',
  $db_name        = 'wordpress',
  $db_host        = 'localhost',
  $db_user        = 'wordpress',
  $db_password    = 'password',
  $wp_owner       = 'root',
  $wp_group       = '0',
  $wp_lang        = '',
  $wp_plugin_dir  = 'DEFAULT',
  $auto_setup     = false,
  $site_name      = 'WordPress',
  $site_admin     = 'admin',
  $admin_pwd      = '',
  $admin_mail     = 'root@localhost', #Invalid acconding to Wordpress Validator
  $wp_multisite   = false,
  $wpmu_accel_redirect    = false,
  $wp_subdomain_install   = false,
  $wp_domain_current_site = 'blog.sbri.org',
  $wp_path_current_site   = '/',
  $wp_site_id_current_site = 1,
  $wp_blog_id_current_site = 1,
) {

  class { 'wordpress::app':
    install_dir   => $install_dir,
    install_url   => $install_url,
    version       => $version,
    db_name       => $db_name,
    db_host       => $db_host,
    db_user       => $db_user,
    db_password   => $db_password,
    wp_owner      => $wp_owner,
    wp_group      => $wp_group,
    wp_lang       => $wp_lang,
    wp_plugin_dir => $wp_plugin_dir,
    wp_multisite  => $wp_multisite,
    wpmu_accel_redirect     => $wpmu_accel_redirect,
    wp_subdomain_install    => $wp_subdomain_install,
    wp_domain_current_site  => $wp_domain_current_site,
    wp_path_current_site    => $wp_path_current_site,
    wp_site_id_current_site => $wp_site_id_current_site,
    wp_blog_id_current_site => $wp_blog_id_current_site,
  }
  if $auto_setup {
    class { 'wordpress::app::setup':
      wp_directory => $install_dir,
      site_name    => $site_name,
      site_admin   => $site_admin,
      admin_pwd    => $admin_pwd,
      admin_mail   => $admin_mail,
    }
    Class['wordpress::app'] -> Class['wordpress::app::setup']
  }

}
