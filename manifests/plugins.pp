# == Define: ohmyzsh::plugins
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
# defaults: (bool) if true, include defined default plugins
# plugins: (string) space separated list of tmux plugins

# === Authors
#
# Reuben Avery <ravery@bitswarm.io>
#
# === Copyright
#
# Copyright 2016 Bitswarm Labs
#
define ohmyzsh::plugins(
  $defaults = true,
  $plugins = ['git'],
) {
  include 'ohmyzsh'
  include 'ohmyzsh::config'

  if $defaults {
    $all_plugins = concat($ohmyzsh::default_plugins, $plugins)
  }
  else {
    $all_plugins = $plugins
  }

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${ohmyzsh::config::home}/${name}"
  }

  if is_array($all_plugins) {
    $plugins_real = join(unique($all_plugins), ' ')
  } else {
    validate_string($all_plugins)
    $plugins_real = $all_plugins
  }

  file_line { "${name}-${plugins_real}-install":
    path    => "${home}/.zshrc",
    line    => "plugins=(${plugins_real})",
    match   => '^plugins=',
    require => Ohmyzsh::Install[$name]
  }
}
