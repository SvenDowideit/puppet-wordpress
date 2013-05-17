class wordpress::db (
  $create_db      = $wordpress::params::create_db,
  $create_db_user = $wordpress::params::create_db_user,
  $db_name        = $wordpress::params::db_name,
  $db_host        = $wordpress::params::db_host,
  $db_user        = $wordpress::params::db_user,
  $db_password    = $wordpress::params::db_password
) inherits wordpress::params {

  validate_bool($create_db,$create_db_user)
  validate_string($db_name,$db_host,$db_user,$db_password)

  ## Set up DB using puppetlabs-mysql defined type
  if $create_db {
    database { $db_name:
      charset => 'utf8',
      require => Class['wordpress::app'],
    }
  }
  if $create_db_user {
    database_user { "${db_user}@${db_host}":
      password_hash => mysql_password($db_password),
      require       => Class['wordpress::app'],
    }
    database_grant { "${db_user}@${db_host}/${db_name}":
      privileges => ['all'],
      require    => Class['wordpress::app'],
    }
  }

}
