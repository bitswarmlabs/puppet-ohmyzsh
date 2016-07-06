define ohmyzsh::uninstall(
  $reset_sh = '/bin/bash',
) {
  include 'ohmyzsh::config'

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${ohmyzsh::config::home}/${name}"
  }

  if $reset_sh == undef or $reset_sh == true {
    $_reset_sh = $ohmyzsh::config::reset_sh
  }
  else {
    $_reset_sh = $reset_sh
  }

  exec { "cp -f ${home}/.zshrc.orig ${home}/.zshrc && rm -f ${home}/.zshrc.orig":
    path   => ['/bin', '/usr/bin'],
    onlyif => "test -d ${home}/.oh-my-zsh && test -e ${home}/.zshrc-orig"
  }
  ~>
  exec { "cp -f /etc/zsh/newuser.zshrc.recommended ${home}/.zshrc && rm -rf ${home}/.oh-my-zsh":
    path   => ['/bin', '/usr/bin'],
    onlyif => "test -d ${home}/.oh-my-zsh && test ! -e ${home}/.zshrc.orig"
  }
  ~>
  file { "${home}/.oh-my-zsh":
    ensure => absent,
  }

  if $_reset_sh {
    if str2bool($ohmyzsh::config::manage_user) and ! defined(User[$name]) {
      user { "ohmyzsh::user ${name}":
        ensure     => present,
        name       => $name,
        managehome => true,
        shell      => $_reset_sh,
        require    => Package[$ohmyzsh::config::zsh_package_name],
      }
    } else {
      User <| title == $name |> {
        shell => $ohmyzsh::config::zsh
      }
    }
  }
}
