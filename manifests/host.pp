define sshuserconfig::host(
  $configLines,
  $user = undef
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
	$config = join($configLines, "\n\t")
	
	file { "${title}_${entry_dest}" :
		path => $entry_dest,
		ensure => 'present',
		content => "Host ${alias}\n\t${config}\n\n",
		notify => Exec['sshuserconfig_generate_config'],
	}
}
