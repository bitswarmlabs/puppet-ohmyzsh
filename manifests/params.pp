# Parameters class for ohmyzsh
class ohmyzsh::params {
  $set_sh = false
  $disable_auto_update = false
  $disable_update_prompt = false

  $manage_zsh = true
  $zsh_package_name = 'zsh'

  $manage_git = true
  $git_package_name = 'git'

  $manage_user = true

  case $::osfamily {
    'Redhat': {
      $zsh = '/bin/zsh'
      $reset_sh = '/bin/bash'
      $os_default_plugins = [
        'fedora'
      ]
    }
    'Debian': {
      $zsh = '/usr/bin/zsh'

      $reset_sh = '/bin/bash'
      if $::operatingsystem == 'Ubuntu' {
        $os_default_plugins = [
          'ubuntu'
        ]
      }
      else {
        $os_default_plugins = [
          'debian'
        ]
      }
    }
    default: {
      $zsh = '/usr/bin/zsh'
      $reset_sh = '/bin/bash'
      $os_default_plugins = []
    }
  }

  if $::ec2_instance_id {
    $environment_default_plugins = [
      'aws',
    ]
  }
  else {
    $environment_default_plugins = []
  }

  $default_plugins = concat($os_default_plugins, $environment_default_plugins)

  $home = '/home'

  $repo_url = 'https://github.com/robbyrussell/oh-my-zsh.git'

  $theme_username_slug = '%n'
  $theme_hostname_slug = '%m'
}
