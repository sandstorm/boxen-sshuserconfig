SSH Config (alias) Boxen Puppet Module
============================
This module allows you to define your local .ssh/config with Boxen.
Since we expect our configuration in Boxen to be complete,
	any local changes in .ssh/config are purged.

The config file is generated in two steps:
* all host-entries are written to an own file using a debian-art .ssh/config.d/<alias>
* all files in config.d are concatenated to .ssh/config

Note that old files and directories in .ssh/config.d are purged.

Installation
---------
To use this module you have to include it to Boxen.
To do so add the following line to the file 'Puppetfile'.
```puppet
github "sshuserconfig", "0.1.0", :repo => "sandstorm/boxen-sshuserconfig"
```

Usage
---------
```puppet
# creates or purges the .ssh/cofig.d in ~/.ssh of the executing user
include sshuserconfig

# actual host-entry
# will be places in .ssh/config and .ssh/config.d/example.net
sshuserconfig::host { "example.net":
	configLines => [
		'Username userName',
		'Port 22',
		'...'
	],
}

# another host-entry
# will be places in .ssh/config and .ssh/config.d/home
sshuserconfig::host { "home":
	configLines => [
		'HostName localhost'
	],
}

# another host-entry, but for the system user 'localUser'
# will be places in .ssh/config and .ssh/config.d/home of localUser
# this features needs improvement (see ToDo)
sshuserconfig::host { "home":
	user = 'localUser',
	configLines => [
		'HostName localhost'
	],
}
```

Requirements
------------

* OS X (see ToDo) 

Manifests
---------

* init.pp : "include sshuserconfig" sets up .ssh/config.d folder correctly (for executing user)
* host.pp : generates new entries

Hints
---------
The local .ssh/config is overridden,
	so make sure to port its full content to your Boxen config BEFORE running Boxen.
A local backup-copy of .ssh/config might suffice as well.

The feature to generate .ssh/config files for users other than the executing user has not been tested sufficiently yet.

Feel free to improve this solution.

ToDo
---------
* remove the OSX requirement and make it Linux compatible (basically just abstract the default user folder - thats it)
* more documention

























