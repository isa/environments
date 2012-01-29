# Environments

Alright, this is my environment setup. Anyone is welcome to steal the logic I used. 

I actually tried many alternative solutions (puppet, chef, babushka, cdist) to setup my new machines, but so far none of them worked the way I want. First of all, all of these solutions have dependencies (they require ruby, python3, etc). None of them are actually using the system built-ins like (bash and powershell). Plus they work best on only one platform. Well, if I'm going to spend that much time writing scripts for each environment, why not rolling my own solution. 

Here we go.. One side note here is, I'm not planning to solve everyone's problem here. Will be solving my own. Anybody who has similar problems can copy/use this.

## Installation

For Ubuntu and OSX you can use the **boot.sh** and for Windows you should use **boot.ps1**. There are of course some pre-conditions for your machines. I'll explain why in a bit. But these are something you have to do anyways. Just follow the instructions for each platform.

### OSX

**Pre-condition**: Well you have to install XCode before moving on unfortunatelly. Sorry folks, nothing I can do about it since Apple moved XCode into the AppStore.

Current setup does following:

1. Installs and updates **HomeBrew**
2. Installs following packages with brew:
   * git
   * ack
   * rlwrap
   * unrar
   * virtualhost.sh
   * macvim
   * python3
   * groovy
   * mercurial
   * fantom
3. After finishing all, it starts installing my minimum required apps:
   * Google Chrome
   * LaunchBar
   * iTerm2
   * Speed Download Lite
4. After above packages are installed, it tries to setup the user's home directory by:
   * Download and configure my [**Vim**vironment](http://github.com/isa/vim-vironment)
   * Creates all the symbolic links necessary to work with anything (.profile, .git-config, .hgrc, etc)

### Ubuntu

Coming soon..
