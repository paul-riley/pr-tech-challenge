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
  String $jenkins_config_file = '/etc/sysconfig/jenkins',
  String $jenkins_port = '8000'
) {

  #Step 0: Limit this to RHEL Family of stuff
  if $::facts['os']['family'] != 'RedHat' {
    err('Installer Failed: Non-Enterprise Linux OS !Centos|!Scientific|!Rocky|!RHEL')
  }

  #Step 1. Put the repos in place & import key, set other config stuff
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

  #This is not awesome, I would use the selinux provider and firewalld
  exec {'turn_off_selinux':
    path        => '/usr/bin',
    command     => 'sudo setenforce 0',
    refreshonly => true
  }
  service { 'firewalld':
    ensure => stopped
  }

  #Step 2. Install the packages
  package { $required_pkgs:
    ensure => installed,
    before => File[$jenkins_config_file]
  }

  #Step 3. Reconfigure /etc/sysconfig/jenkins. Normally would use file_line from std_lib
  file { $jenkins_config_file:
    ensure  => file,
    content => epp('prtechchallenge/jenkins_port.epp'),
    owner   => root,
    group   => root,
    mode    => '0600',
    notify  => Service['jenkins']
  }

  #Step 4. Make sure the service is started after reconfiguring
  service { 'jenkins':
    ensure  => running,
    before  => Exec['turn_off_selinux'],
    require => Package[$required_pkgs[-1]]
  }

}
