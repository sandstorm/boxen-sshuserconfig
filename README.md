SSH Config (alias) Boxen Puppet Module
============================

Basically I started to derive from Jimdo/puppet-sshuserconfig,  but in the end I rather completely rewrote the functionality (sadly).

This module lets you maintain your `.ssh/config` a sane way, using the debian-style `.ssh/config.d/<alias>` folder
Every entry in `.ssh/config.d/*` will be used to generate the `.ssh/config` file automatically - so it does not change the way ssh works,
but rather generates the config file.

This makes maintaing entries much easier and convenient.

This module is perfectly compatible with Boxen.

Usage
---------
```puppet
# this does setup the .ssh config, backups your old one 
#and uses it as an entry in .ssh/config.d/config_old
include sshuserconfig 

# that actually adds a new entry, which will be place under
# ~/.ssh/config.d/aliasname
sshuserconfig::host {
"aliasname":
remote_hostname => "somehost.tld",
remote_username => 'root',
}

#you can also set the 
# - priv_key_name
# - remote_port
# - user ( the user this entry should stored for, so the "destination home folder")
```

Requirements
------------

* OSX (for now) 
* Boxen

Manifests
---------

* init.pp : use it like `include sshuserconfig` to setup your .ssh folder correctly. 
* host.pp : use this to generate a new entry
