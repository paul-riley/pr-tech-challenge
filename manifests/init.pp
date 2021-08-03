# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include prtechchallenge
class prtechchallenge {

  #Step 0: Limit this to RHEL Family of stuff
  if $::facts['os']['family'] != 'RedHat' {
    err('Installer Failed: Non-Enterprise Linux OS !Centos|!Scientific|!Rocky|!RHEL')
  }
  #Step 1. Put the repos in place & import key.
  file { '/etc/yum.repos.d/jenkins.repo':
    ensure  => present,
    content => file('prtechchallenge/jenkins.repo'),
    owner   => root,
    group   => root,
    notify  => Exec['get_repo_key']
  }

  exec {'get_repo_key':
    path        => '/usr/bin',
    command     => 'sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
    refreshonly => true
  }

  #Step 2. Configure the custom stuff port 8000

  #Step 3. Install the Package

  #Step 4. Make sure the service is started after reconfiguring

}
