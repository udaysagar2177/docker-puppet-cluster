node puppet {
	# Here we configure the puppet master to use PuppetDB,
	# and tell it that the hostname is 'puppetdb'
	class { 'puppetdb':
	#	confdir => '/etc/puppetdb/conf.d'
	}

	#class { 'puppetdb::master::config':
  #  puppetdb_server => 'puppetdb',
  #}



	file { '/opt/hello111':
		content => "jello!"
	}

}

node puppetdb {
	# Configure puppetdb and its underlying database

}

node default {
	file { '/opt/hello':
		content => "jello!"
	}
}
