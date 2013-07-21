class sshuserconfig {
  #TODO: make an OS exception here or an variable, so Linux users can set /home as path for user
  $ssh_dir = "/Users/${::luser}/.ssh"
  $ssh_config_file = "${ssh_dir}/config"
  $ssh_config_dir = "${ssh_dir}/config.d"
  $firsrunlock = "${ssh_dir}/.sshuserconfig"

  file { $ssh_dir:
    ensure => "directory",
    mode => 0700
  }

  file { $ssh_config_dir:
    ensure => "directory",
    mode => 0700,
    recurse => true,
  }

  # ensure that we have run once, so never trigger the first run again
  file { $firsrunlock:
    ensure => 'present',
    notify => Exec["alias_old_config"],
  }

  file { $ssh_config_file :
    owner => $::luser
  }

  # backup config file if first run
  exec { "backup_config":
    command => "cp ${ssh_config_file} ${ssh_config_file}.old",
    onlyif => ["test -f {$ssh_config_file}"],
    refreshonly => true,
  }
  exec { "alias_old_config":
    command => "mv ${ssh_config_file} ${ssh_config_dir}/config_old_backup",
    require => Exec["backup_config"], #backup first
    onlyif => ["test -f {$ssh_config_file}"],
    refreshonly => true
  }
}
