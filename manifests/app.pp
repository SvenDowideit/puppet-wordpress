# Wordpress
# Paramater defaults come from Class['wordpress']
class wordpress::app (
  $version, $install_dir, $install_url,
  $db_name, $db_host, $db_user, $db_password,
  $wp_owner, $wp_group, $wp_lang,
  $wp_plugin_dir, $wp_allow_multisite,
  $wget_package = $wordpress::params::wget_package
) inherits wordpress::params {

  ## Resource defaults
  File {
    owner  => $wp_owner,
    group  => $wp_group,
    mode   => '0644',
  }

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $install_dir,
    user      => $wp_owner,
    group     => $wp_group,
  }

  if !defined(Package[$wget_package]) {
    package { $wget_package : ensure => 'present' }
  }

  ## Installation directory
  file { $install_dir:
    ensure  => directory,
    recurse => true,
  }
  if $wp_plugin_dir != 'DEFAULT' {
    file { $wp_plugin_dir:
      ensure  => directory,
      recurse => true,
    }
  }

  ## Wordpress Tarball
  if $version == 'latest' {
    $download = 'latest.tar.gz'
  } else {
    $download = "wordpress-${version}.tar.gz"
  }

  ## Download and extract; specific version or latest.
  exec { 'download-wordpress-pkg':
    command => "wget -nc ${install_url}/${download}",
    creates => "${install_dir}/${download}",
    require => File[$install_dir],
  }
  -> exec { 'extract-wordpress-pkg':
    command => "tar zxf ./${download} --strip-components=1",
    creates => "${install_dir}/index.php",
  }

  ## Configure wordpress
  file { "${install_dir}/wp-keysalts.php":
    ensure  => present,
    content => template('wordpress/wp-keysalts.php.erb'),
    replace => false,
    require => Exec['extract-wordpress-pkg'],
  }

  file { "${install_dir}/wp-config.php":
    ensure  => present,
    content => template('wordpress/wp-config.php.erb'),
    require => Exec['extract-wordpress-pkg'],
  }

}
