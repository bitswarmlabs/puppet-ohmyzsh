# View README.md for full documentation.
#
# === Authors
#
# Reuben Avery <ravery@bitswarm.io>
#
# === Copyright
#
# Copyright 2016 Bitswarm Labs
#
class ohmyzsh(
  $manage_zsh      = $ohmyzsh::params::manage_zsh,
  $manage_git      = $ohmyzsh::params::manage_git,
  $plugins         = undef,
) inherits ohmyzsh::params {
  include 'ohmyzsh::config'

  if $plugins {
    $default_plugins = concat($ohmyzsh::config::plugins, $plugins)
  }
  else {
    $default_plugins = $ohmyzsh::config::plugins
  }

  if str2bool($manage_zsh) or str2bool($ohmyzsh::config::manage_zsh) {
    if ! defined(Package[$ohmyzsh::config::zsh_package_name]) {
      package { $ohmyzsh::config::zsh_package_name:
        ensure => present,
      }
    }
  }

  if str2bool($manage_git) or str2bool($ohmyzsh::config::manage_git) {
    if ! defined(Package[$ohmyzsh::config::git_package_name]) {
      package { $ohmyzsh::config::git_package_name:
        ensure => present,
      }
    }
  }
}
