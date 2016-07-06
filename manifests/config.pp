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
class ohmyzsh::config(
  $zsh                   = $ohmyzsh::params::zsh,
  $manage_user           = $ohmyzsh::params::manage_user,
  $set_sh                = $ohmyzsh::params::set_sh,
  $reset_sh              = $ohmyzsh::params::reset_sh,
  $disable_auto_update   = $ohmyzsh::params::disable_auto_update,
  $disable_update_prompt = $ohmyzsh::params::disable_update_prompt,
  $repo_url              = $ohmyzsh::params::repo_url,
  $plugins               = $ohmyzsh::params::default_plugins,
  $manage_zsh            = $ohmyzsh::params::manage_zsh,
  $zsh_package_name      = $ohmyzsh::params::zsh_package_name,
  $manage_git            = $ohmyzsh::params::manage_zsh,
  $git_package_name      = $ohmyzsh::params::git_package_name,
  $theme_username_slug   = $ohmyzsh::params::theme_username_slug,
  $theme_hostname_slug   = $ohmyzsh::params::theme_hostname_slug,
) inherits ohmyzsh::params {

}
