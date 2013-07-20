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
  #TODO: make an OS exception here or an variable, so Linux users can set /home as path for user folders
  #$rootgroup = $osfamily ? {
  #        'Solaris'          => 'wheel',
  #        /(Darwin|FreeBSD)/ => 'wheel',
  #        default            => 'root',
  #    }
  $ssh_dir = "/Users/${unix_user}/.ssh"
  $privkey_path = "${ssh_dir}/$priv_key_name"  
  $alias = "${title}"
  $entry_dest = "${ssh_dir}/config.d/${alias}"

  file { $entry_dest :
    content => "Host ${alias}
  HostName ${remote_hostname}
  Port ${remote_port}
  User ${remote_username}
  IdentityFile ${privkey_path}\n\n",
	ensure => 'present',
#	notify => Exec['generate_config'],
  } 
  
  $ssh_config_file = "${ssh_dir}/config"
  $ssh_config_dir = "${ssh_dir}/config.d"   
  # that regenerates our .ssh/config
 
  exec { "generate_config_for_${$entry_dest}":
    command => "cat $ssh_config_dir/* >> $ssh_config_file",	
    require => [Exec["Sshuserconfig::clear_config"]],
	subscribe => File[$entry_dest],
	refreshonly => true,
	#before => $entry_dest,
  #subscribe => File[$ssh_config_dir], #does not work yet
  }	
}
