# Creates plugins in uwsgi via the emporer plugin dir
define uwsgi::plugin (
  $url,
  $plugin_name = $title,
){
  include ::uwsgi

  if $::uwsgi::emeror_mode and $url != 'package' {
    exec{"uwsgi --build-plugin ${url}":
      cwd     => $::uwsgi::plugins_directory,
      creates => "${::uwsgi::plugins_directory}/${plugin_name}_plugin.so",
    }
  }

  else {
    package { $plugin_name:
      ensure => installed;
    }
  }
}
