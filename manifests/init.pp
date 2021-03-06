# @summary A short summary of the purpose of this class
#
# This installs jenkins and configures it to use a custom port.
#  It has a side effect on turning off selinux and firewalld.
#  Not recommended for production. Scoped to EL family only.
#
# @example
#   include prtechchallenge
class prtechchallenge(
  Array[String] $required_pkgs = ['java-11-openjdk-devel', 'jenkins'],
  String $selinux_status = 'disabled',
  String $jenkins_port = '8000'
) {

  #Step 0: Limit this to RHEL Family of stuff
  if $::facts['os']['family'] != 'RedHat' {
    fail('Installer Failed: Non-Enterprise Linux OS !Centos|!Scientific|!Rocky|!RHEL')
  }

  #Step 1. Put the repos in place & import key, set other config stuff
  file { '/etc/yum.repos.d/jenkins.repo':
    ensure  => present,
    content => file('prtechchallenge/jenkins.repo'),
    owner   => root,
    group   => root,
    notify  => Exec['get_repo_key']
  }

  exec { 'get_repo_key':
    path        => '/usr/bin',
    command     => 'sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
    refreshonly => true
  }

  #This is not awesome, I would use the selinux provider and firewalld
  exec { 'turn_off_selinux':
    path        => '/usr/bin',
    command     => 'sudo setenforce 0',
    refreshonly => true
  }
  file {'/etc/selinux/config':
    ensure  => file,
    content => epp('prtechchallenge/selinux_config.epp'),
    owner   => root,
    group   => root,
    mode    => '0644'
  }

  service { 'firewalld':
    ensure => stopped,
    before => Service['jenkins']
  }

  #Step 2. Install the packages
  package { $required_pkgs:
    ensure => installed,
    before => File['/etc/sysconfig/jenkins']
  }

  #Step 3. Reconfigure /etc/sysconfig/jenkins. Normally would use file_line from std_lib
  file { '/etc/sysconfig/jenkins':
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
    require => Package[$required_pkgs[-1]]
  }

}
