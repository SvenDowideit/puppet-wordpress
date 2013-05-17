# Default Parameters for Wordpress
class wordpress::params {
  $install_dir    = '/opt/wordpress'
  $install_url    = 'http://wordpress.org'
  $version        = '3.5'
  $create_db      = true
  $create_db_user = true
  $db_name        = 'wordpress'
  $db_host        = 'localhost'
  $db_user        = 'wordpress'
  $db_password    = 'password'
  $wp_owner       = 'root'
  $wp_group       = '0'
  $wp_lang        = ''
  $wp_plugin_dir  = 'DEFAULT'
}
