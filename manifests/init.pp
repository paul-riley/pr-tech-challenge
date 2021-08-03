# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include prtechchallenge
class prtechchallenge(
  String $repo_file = '/etc/yum.repos.d/jenkins.repo',
  String $repo_content = 'prtechchallenge/jenkins.repo',
  String $repo_key = 'https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
  Array[String] $required_pkgs = ['java-11-openjdk-devel', 'jenkins'],
  String $jenkins_port = '8000'
) {

  #Step 0: Limit this to RHEL Family of stuff
  if $::facts['os']['family'] != 'RedHat' {
    err('Installer Failed: Non-Enterprise Linux OS !Centos|!Scientific|!Rocky|!RHEL')
  }

  #Step 1. Put the repos in place & import key.
  file { $repo_file:
    ensure  => present,
    content => file($repo_content),
    owner   => root,
    group   => root,
    notify  => Exec['get_repo_key']
  }

  exec { 'get_repo_key':
    path        => '/usr/bin',
    command     => "sudo rpm --import ${repo_key}",
    refreshonly => true
  }

  #Step 2. Configure the custom stuff port 8000
  file { '/etc/default/jenkins':
    ensure  => file,
    content => epp('prtechchallenge/jenkins_port.epp'),
    notify  => Service['jenkins']
  }

  #Step 3. Install the packages
  package { $required_pkgs:
    ensure => installed
  }

  #Step 4. Make sure the service is started after reconfiguring
  service { 'jenkins':
    ensure  => running,
    require => Package[$required_pkgs[-1]]
  }

}
