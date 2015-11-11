node puppet {
        class { 'puppetdb::globals':
  version => '2.3.8-1puppetlabs1',
}


	# Here we configure the puppet master to use PuppetDB,
	# and tell it that the hostname is 'puppetdb'
	class { 'puppetdb':
	}

	class { 'puppetdb::master::config':
        #  puppetdb_server => '127.0.0.1',
        }



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
