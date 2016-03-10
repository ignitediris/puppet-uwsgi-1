# == Class uwsgi::config
#
# This class is called from uwsgi for service config.
#
class uwsgi::config {

  file { $::uwsgi::config_directory:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file {
    $::uwsgi::log_dir:
      ensure => directory,
      owner  => $uwsgi::user_real,
      group  => $uwsgi::group_real;
    $::uwsgi::pid_dir:
      ensure => directory,
      owner  => $uwsgi::user_real,
      group  => $uwsgi::group_real;
  }

  if $uwsgi::plugins_directory {
    file { $::uwsgi::plugins_directory:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
    }
  }

  if $::uwsgi::manage_ini_file {
    file { $::uwsgi::config_file:
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('uwsgi/uwsgi.ini.erb'),
      require => File[$::uwsgi::config_directory],
    }
  }

  if $::uwsgi::manage_service_file {
    file { $::uwsgi::service_file:
      ensure  => $::uwsgi::service_file_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => $::uwsgi::service_mode,
      content => template($::uwsgi::service_file_template),
    }
  }

  file { $::uwsgi::app_directory:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    recurse => true,
    purge   => $::uwsgi::purge,
    mode    => '0644',
    require => File[$::uwsgi::config_directory],
  }
}
