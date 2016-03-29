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
  
  #The bitbucket module uses archive or staging module
  #which requires unzip but doesn't seem to install it
  package { 'unzip':
    ensure => present,
  }
  package { 'git' :
    ensure => present,
  }
  class { 'java' :
    package => 'java-1.8.0-openjdk-devel',
  } -> 
  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
  } ->
  class { 'postgresql::server': } ->
#  class { 'bitbucket::gc': }
#  class { 'bitbucket::facts': }
  postgresql::server::db { 'bitbucket':
    user     => 'bitbucket',
    password => postgresql_password('bitbucket', 'password'),
  } ->

  class { 'bitbucket':
    javahome    => '/etc/alternatives/java_sdk',
    #dev.mode grants a 24-hour license for testing
    java_opts   => '-Datlassian.dev.mode=true',
    version     => '4.4.1',
    require     => [ Package['git', 'unzip'] ]
  }

}

node 'puppet-master'{

}

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

