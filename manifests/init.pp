# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include prtechchallenge
class prtechchallenge(
  String $repo_dir = '/etc/yum.repos.d/jenkins.repo',
  String $repo_file = 'prtechchallenge/jenkins.repo',
  String $repo_key = 'https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
  Array[String] $required_pkgs = ['java-11-openjdk-devel', 'jenkins']
) {

  #Step 0: Limit this to RHEL Family of stuff
  if $::facts['os']['family'] != 'RedHat' {
    err('Installer Failed: Non-Enterprise Linux OS !Centos|!Scientific|!Rocky|!RHEL')
  }
  #Step 1. Put the repos in place & import key.
  file { $repo_dir:
    ensure  => present,
    content => file($repo_file),
    owner   => root,
    group   => root,
    notify  => Exec['get_repo_key']
  }

  exec {'get_repo_key':
    path        => '/usr/bin',
    command     => "sudo rpm --import ${repo_key}",
    refreshonly => true
  }

  #Step 3. Install the packages

  package {$required_pkgs:
    ensure => installed
  }

  #Step 2. Configure the custom stuff port 8000

  #Step 4. Make sure the service is started after reconfiguring

}
