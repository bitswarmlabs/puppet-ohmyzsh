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
  $manage_zsh      = 'UNSET',
  $manage_git      = 'UNSET',
) inherits ohmyzsh::params {
  include 'ohmyzsh::config'

  $_manage_zsh = $manage_zsh ? {
    'UNSET' => $ohmyzsh::config::manage_zsh,
    default => $manage_zsh,
  }

  $_manage_git = $manage_git ? {
    'UNSET' => $ohmyzsh::config::manage_git,
    default => $manage_git,
  }

  anchor { 'ohmyzsh::begin': }

  if str2bool($_manage_zsh) {
    if ! defined(Package[$ohmyzsh::config::zsh_package_name]) {
      package { $ohmyzsh::config::zsh_package_name:
        ensure => present,
      }
      ~>Anchor['ohmyzsh::end']
    }
  }

  if str2bool($_manage_git) {
    if ! defined(Package[$ohmyzsh::config::git_package_name]) {
      package { $ohmyzsh::config::git_package_name:
        ensure => present,
      }
      ~>Anchor['ohmyzsh::end']
    }
  }

  anchor { 'ohmyzsh::end': }
}
