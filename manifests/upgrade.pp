# == Define: ohmyzsh::upgrade
#
# This is the ohmyzsh module. It installs oh-my-zsh for a user and changes
# their shell to zsh. It has been tested under Ubuntu.
#
# This module is called ohmyzsh as Puppet does not support hyphens in module
# names.
#
# oh-my-zsh is a community-driven framework for managing your zsh configuration.
#
# === Parameters
#
# None.
#
# === Authors
#
# Reuben Avery <ravery@bitswarm.io>
#
# === Copyright
#
# Copyright 2016 Bitswarm Labs
#
define ohmyzsh::upgrade (
  $schedule = 'daily',
) {
  include 'ohmyzsh::config'

  if ! defined(Schedule['daily']) {
    schedule { 'daily':
      range  => '2 - 4',
      period => 'daily',
      repeat => 1,
    }
  }

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${ohmyzsh::config::home}/${name}"
  }

  exec { "ohmyzsh::git upgrade ${name}":
    command  => 'git pull --rebase --stat origin master',
    path     => ['/bin', '/usr/bin'],
    cwd      => "${home}/.oh-my-zsh",
    user     => $name,
    schedule => $schedule,
    require  => Package['git'],
  }

}
