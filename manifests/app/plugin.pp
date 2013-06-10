# Defined Resource for installing plugins
#
# The Puppet DSL makes it difficult to cut up a URI into file and URL.
#
# [*name*] - The simple name of the plugin, as known to Wordpress
# [*download_file*] - The name of the plugin file to download.
# [*download_url*] - The URL of the plugin file to download.
#
define wordpress::app::plugin (
  $file           = '',
  $url            = 'http://downloads.wordpress.org/plugin',
  $ensure         = 'present',
  $plugin_dir     = $wordpress::wp_plugin_dir,
  $install_dir    = $wordpress::install_dir
) {

  if $plugin_dir == 'DEFAULT' {
    $plugin_dir_real = "${install_dir}/wp-content/plugins"
  } else {
    $plugin_dir_real = $plugin_dir
  }

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $plugin_dir_real,
  }

  if ( $ensure == 'absent' ) {

    file { "${plugin_dir_real}/${name}" :
      ensure => absent,
    }
    # Do we need to restart the web service?

  } else {

    include wordpress::params
    $unzip_package = $wordpress::params::unzip_package

    if !defined(Package[$unzip_package]) {
      package { $unzip_package : ensure => 'present' }
    }

    # Download and Extract
    exec { "download-wordpress-plugin-${name}":
      command => "wget -nc ${url}/${file}",
      creates => "${plugin_dir_real}/${file}",
    }
    -> exec { "extract-wordpress-plugin-${name}":
      command => "unzip ./${file}",
      creates => "${plugin_dir_real}/${name}",
      require => Package[$unzip_package],
    }

    # Installation and configuration is left to the Wordpress GUI

  }
}
