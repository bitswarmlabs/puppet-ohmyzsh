# puppet-ohmyzsh

This is a [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) module. It
installs oh-my-zsh for a user and can change their shell to zsh. It can install
and configure themes and plugins for users.

oh-my-zsh is a community-driven framework for managing your zsh configuration.
See [https://github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
for more details.

## Usage

```puppet
# disable management of zsh and git packages:
class { 'ohmyzsh::config': manage_zsh => false, manage_git => false }

# install for a single user
ohmyzsh::install { 'user1': }

# install for multiple users in one shot and set their shell to zsh
ohmyzsh::install { ['root', 'user1']: set_sh => true }

# install and disable automatic updating
ohmyzsh::install { 'user2': disable_auto_update => true }

# install and disable update prompt so updates are applied automatically
ohmyzsh::install { 'user2': disable_update_prompt => true }

# install a theme for a user
ohmyzsh::fetch::theme { 'root': url => 'http://zanloy.com/files/dotfiles/oh-my-zsh/squared.zsh-theme' }

# set a theme for a user
ohmyzsh::theme { ['root', 'user1']: } # would install 'bitswarmops' theme as default

ohmyzsh::theme { ['root', 'user1']: theme => 'dpoggi' } # specific theme

# changing the hostname slug of bitswarmops theme to use puppet fact:
class { 'ohmyzsh::config': theme_hostname_slug => $::clientcert }
ohmyzsh::theme { ['root', 'user1']: }

# activate default plugins for a user
ohmyzsh::plugins { 'user1': }

# or activate specific plugins for a user
ohmyzsh::plugins { 'user1': plugins => 'git github' }

# upgrade oh-my-zsh for a single user
ohmyzsh::upgrade { 'user1': }

# upgrade oh-my-zsh on a different schedule (only 'daily' is defined, you are responsible for creating additional schedules)
ohmyzsh::upgrade { 'user1': schedule => 'weekly' }
```

Support
-------

Please log tickets and issues on [GitHub](https://github.com/bitswarmlabs/puppet-ohmyzsh)


Acknowlegments
--------------

This module was originally a fork of [zanloy/ohmyzsh](https://github.com/zanloy/puppet-ohmyzsh) at version 1.0.4, itself a fork of [acme/ohmyzsh](https://github.com/acme/puppet-acme-oh-my-zsh) at version 0.1.3
