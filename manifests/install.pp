# == Define: ohmyzsh::install
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
# set_sh: (boolean) whether to change the user shell to zsh
# disable_auto_update: (boolean) whether to prompt for updates bi-weekly
#
# === Authors
#
# Reuben Avery <ravery@bitswarm.io>
#
# === Copyright
#
# Copyright 2016 Bitswarm Labs
#
define ohmyzsh::install(
  $set_sh                = undef,
  $disable_auto_update   = undef,
  $disable_update_prompt = undef,
) {
  include 'ohmyzsh'
  include 'ohmyzsh::config'

  if $set_sh == undef {
    $_set_sh = $ohmyzsh::config::set_sh
  }
  else {
    $_set_sh = $set_sh
  }

  if $disable_auto_update == undef {
    $_disable_auto_update = $ohmyzsh::config::disable_auto_update
  }
  else {
    $_disable_auto_update = $disable_auto_update
  }

  if $disable_update_prompt == undef {
    $_disable_update_prompt = $ohmyzsh::config::disable_update_prompt
  }
  else {
    $_disable_update_prompt = $disable_update_prompt
  }

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${ohmyzsh::config::home}/${name}"
  }

  exec { "ohmyzsh::git clone ${name}":
    creates => "${home}/.oh-my-zsh",
    command => "git clone ${ohmyzsh::config::repo_url} ${home}/.oh-my-zsh || (rmdir ${home}/.oh-my-zsh && exit 1)",
    cwd     => $home,
    path    => ['/bin', '/usr/bin'],
    onlyif  => "getent passwd ${name} | cut -d : -f 6 | xargs test -e",
    user    => $name,
    require => Package[$ohmyzsh::config::git_package_name],
  }

  exec { "cp -f ${home}/.zshrc ${home}/.zshrc.orig":
    path    => ['/bin', '/usr/bin'],
    cwd     => $home,
    user    => $name,
    onlyif  => "test ! -d ${home}/.oh-my-zsh && test -e ${home}/.zshrc",
  }
  ~>
  exec { "ohmyzsh::cp .zshrc ${name}":
    creates => "${home}/.zshrc",
    command => "cp -f ${home}/.oh-my-zsh/templates/zshrc.zsh-template ${home}/.zshrc",
    cwd     => $home,
    path    => ['/bin', '/usr/bin'],
    onlyif  => "getent passwd ${name} | cut -d : -f 6 | xargs test -e",
    user    => $name,
    require => Exec["ohmyzsh::git clone ${name}"],
  }
  ->
  file { "${home}/.zshrc":
    ensure  => file,
    audit   => content,
  }

  $theme_username_slug = $ohmyzsh::config::theme_username_slug
  $theme_hostname_slug = $ohmyzsh::config::theme_hostname_slug

  file { "${home}/.oh-my-zsh/themes/bitswarmops.zsh-theme":
    ensure  => file,
    content => template('ohmyzsh/bitswarmops-theme.erb'),
    require => Exec["ohmyzsh::git clone ${name}"],
  }

  if $_set_sh {
    if str2bool($ohmyzsh::config::manage_user) and ! defined(User[$name]) {
      user { "ohmyzsh::user ${name}":
        ensure     => present,
        name       => $name,
        managehome => true,
        shell      => $ohmyzsh::config::zsh,
        require    => Package[$ohmyzsh::config::zsh_package_name],
      }
    } else {
      User <| title == $name |> {
        shell => $ohmyzsh::config::zsh
      }
    }
  }


  file_line { "ohmyzsh::disable_auto_update ${name}":
    path      => "${home}/.zshrc",
    line      => "DISABLE_AUTO_UPDATE=\"${_disable_auto_update}\"",
    match     => '.*DISABLE_AUTO_UPDATE.*',
    subscribe => File["${home}/.zshrc"],
  }

  file_line { "ohmyzsh::disable_update_prompt ${name}":
    path    => "${home}/.zshrc",
    line    => "DISABLE_UPDATE_PROMPT=\"${_disable_update_prompt}\"",
    match   => '.*DISABLE_UPDATE_PROMPT.*',
    subscribe => File["${home}/.zshrc"],
  }
}
