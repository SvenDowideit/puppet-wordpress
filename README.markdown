# WordPress Module

## Overview

This will set up an installation of Wordpress and plugins.

## Capabilities

Installation includes:

- Download and extract wordpress files.
- Configuration of WordPress DB connection parameters
- Generate configuration with secure keys and salts.
- Optional creation of MySQL database/user/permissions.
- Optional activate the Wordpress admin user account.
- Optional download and extract plugin files.

Requires:

- Database server is already installed and configured.
- `database` resource type acts on installed database server.
- Web serer is already installed and configured.

## Parameters

* `install_dir`<br />
  Specifies the directory into which wordpress should be installed. Default: `/opt/wordpress`

* `install_url`<br />
  Specifies the url from which the wordpress tarball should be downloaded.  Default: `http://wordpress.org`

* `version`<br />
  Specifies the version of wordpress to install. Default: `latest`

* `db_name`<br />
  Specifies the database name which the wordpress module should be configured to use. Default: `wordpress`

* `db_host`<br />
  Specifies the database host to connect to. Default: `localhost`

* `db_user`<br />
  Specifies the database user. Default: `wordpress`

* `db_password`<br />
  Specifies the database user's password in plaintext. Default: `password`

* `wp_owner`<br />
  Specifies the owner of the wordpress files. Default: `root`

* `wp_group`<br />
  Specifies the group of the wordpress files. Default: `0` (\*BSD/Darwin compatible GID)

* `wp_lang` <br />
  WordPress Localized Language. Default: ``

* `wp_plugin_dir` <br />
  WordPress Plugin Directory. Full path, no trailing slash. Default: WordPress Default

* `wp_allow_multisite` <br />
  Enable MultiSite mode. Default: `false`

* `auto_setup` <br />
  Automatically setup the local admin user; automates the "Famous 5-Minute Setup". Default: `false`

* `site_name` <br />
  The name of the wordpress site. Default: `WordPress`

* `site_admin` <br />
  The name of the local admin user. Default: `admin`

* `admin_pwd` <br />
  The password for the admin user. If not given WordPress will generate one
  and it isn't captured, so this option is strongly recomended. Default: ``

* `admin_mail`<br />
  The email address for the admin user. If not specified the automatic setup
  will fail.

## Example Usage

```puppet
class { 'wordpress':
  install_dir    => '/var/www/myblog',
  plugin_dir     => '/var/www/myblog/plugins',
  version        => '3.5',
  db_name        => 'wpdb',
  db_host        => 'mysql.my.domain',
  db_user        => 'wordpressdb',
  db_password    => 'password',
  auto_setup     => true,
  site_name      => 'My Blog',
  site_admin     => 'admin',
  admin_pwd      => 'secret',
  admin_mail     => 'webmaster@my.domain',
  wp_owner       => 'www-data',
  wp_group       => '33',
}

wordpress::app::plugin { 'calendar':
  file  => 'calendar.1.3.3.zip',
  url  => 'http://downloads.wordpress.org/plugin',
}
```

##
Patches and pull requests welcome.
