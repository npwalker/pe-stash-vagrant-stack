## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => "${settings::server}",
  path   => false,
}

notify { "servername is ${settings::server}": }

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node 'stash-server' {
  
  class { 'java' :
    version => '1.7.0.75-2.5.4.0.el6_6',
  } -> 
   
  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
  }->
  class { 'postgresql::server': } ->
#  class { 'stash::gc': }
#  class { 'stash::facts': }
  postgresql::server::db { 'stash':
    user     => 'stash',
    password => postgresql_password('stash', 'password'),
  } ->

  class { 'stash':
    javahome    => '/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.75.x86_64',
    #dev.mode grants a 24-hour license for testing
    java_opts   => '-Datlassian.dev.mode=true'
  }

  file { '/opt/puppet/sbin/stash_mco.rb':
    source => 'puppet:///modules/r10k/stash_mco.rb',
  }

}

node 'puppet-master'{

  class {'r10k::webhook::config':
    use_mcollective => false,
  }

  class {'r10k::webhook':
    user    => 'root',
    group   => '0',
    require => Class['r10k::webhook::config'],
  }
}

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

