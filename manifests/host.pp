define sshuserconfig::host(
  $remote_hostname = undef,
  $remote_port = undef,
  $remote_username = undef,
  $priv_key_name = undef,
  $user = undef,
) {
	#determine were to store the entry (for which user)
	$unix_user = $user ? {
		undef   => $::luser,
		default => $user
	}

	# TODO: make an OS exception here or an variable, so Linux users can set /home as path for user folders
	# $rootgroup = $osfamily ? {
	#        'Solaris'          => 'wheel',
	#        /(Darwin|FreeBSD)/ => 'wheel',
	#        default            => 'root',
	#    }
	$ssh_dir = "/Users/${unix_user}/.ssh"
	$alias = "${title}"
	$entry_dest = "${ssh_dir}/config.d/${alias}"

	$content = "Host ${alias}"
	unless $remote_hostname == undef {
		$content += "\n\tHostName ${remote_hostname}"
	}
	unless $remote_port == undef {
		$content += "\n\tPort ${remote_port}"
	}
	unless $remote_username == undef {
		$content += "\n\tUser ${remote_username}"
	}
	unless $priv_key_name == undef {
		$content += "\n\tIdentityFile ${ssh_dir}/${priv_key_name}"
	}
	$content += "\n\n"
	
	file { "${title}_${entry_dest}" :
		path => $entry_dest,
		ensure => 'present',
		content => $content,
		notify => Exec['sshuserconfig_generate_config'],
	}
}
