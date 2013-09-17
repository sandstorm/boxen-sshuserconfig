define sshuserconfig::host(
  $remote_hostname,
  $remote_username,
  $priv_key_name = 'id_rsa',
  $user = undef,
  $remote_port = 22,
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
	$privkey_path = "${ssh_dir}/$priv_key_name"
	$alias = "${title}"
	$entry_dest = "${ssh_dir}/config.d/${alias}"

	file { "${title}_${entry_dest}" :
		path => $entry_dest,
		ensure => 'present',
		content => "Host ${alias}
			HostName ${remote_hostname}
			Port ${remote_port}
			User ${remote_username}
			IdentityFile ${privkey_path}\n\n",
		notify => Exec['sshuserconfig_refresh_config'],
	}
}
