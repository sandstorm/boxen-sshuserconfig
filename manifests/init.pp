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
		purge => true
	}
	
	exec { "sshuserconfig_generate_config" :
		command => "cat $ssh_config_dir/* > $ssh_config_file",
		refreshonly => true,
	}
}
