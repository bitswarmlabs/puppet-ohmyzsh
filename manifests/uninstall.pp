define ohmyzsh::uninstall(
  $set_sh = undef,
) {
  include 'ohmyzsh::config'

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${ohmyzsh::config::home}/${name}"
  }

  exec { "cp -f ${home}/.zshrc.orig ${home}/.zshrc && rm -f ${home}/.zshrc.orig":
    onlyif => "test -d ${home}/.oh-my-zsh && test -e ${home}/.zshrc-orig"
  }
  ~>
  exec { "cp -f /etc/zsh/newuser.zshrc.recommended ${home}/.zshrc":
    onlyif => "test -d ${home}/.oh-my-zsh && test ! -e ${home}/.zshrc.orig"
  }
  ~>
  file { "${home}/.oh-my-zsh":
    ensure => absent,
    force => true,
  }
}
