# prtechchallenge

Paul Riley's Puppet Professional Services Engineer Tech Challenge

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with prtechchallenge](#setup)
    * [What prtechchallenge affects](#what-prtechchallenge-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with prtechchallenge](#beginning-with-prtechchallenge)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures the Jenkins to run on a specified port.

## Setup

### What prtechchallenge affects

* Firewalld service will disabled.
* Selinux will be disabled.
* Openjdk 11 will be installed.
* This is not for a production system due to the changes above.

### Setup Requirements

The only requirement is an Enterprise Linux Operating System, with access
to the Internet

### Beginning with prtechchallenge

Clone the module into your repository, then add the module to a Puppetfile to
ensure that Codemanager/ Hiera imports the module. The moduel can be modified
to use a different port, or allow for Hiera/Code Manager to override port 8000.

## Usage

This module allows for the installation and reconfiguration of Jenkins.
Currently, this modules sets up the repositories, installs the Openjdk 11
package, installs Jenkins, reconfigures the /etc/syscconfig/jenkins file for
a port, then ensures Jenkins is running.

## Limitations

This module is limited to a proof of concept on creating a basic module,
configuration ordering, and ensuring a service is running.

## Development

This module is released using the Apache 2.0 license. All work is originally
developed by Paul Riley
