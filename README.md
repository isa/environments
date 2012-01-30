# Environments

Alright, this is my environment setup. Anyone is welcome to steal the logic I used. 

I actually tried many alternative solutions (puppet, chef, babushka, cdist) to setup my new machines, but so far none of them worked the way I want. First of all, all of these solutions have dependencies (they require ruby, python3, etc). None of them are actually using the system built-ins like (bash and powershell). Plus they work best on only one platform. Well, if I'm going to spend that much time writing scripts for each environment, why not rolling my own solution. 

Here we go.. One side note here is, I'm not planning to solve everyone's problem here. Will be solving my own. Anybody who has similar problems can copy/use this.

## Installation

For Ubuntu and OSX you can use the **boot.sh** and for Windows you should use **boot.ps1**. There are of course some pre-conditions for your machines. I'll explain why in a bit. But these are the things you have to do it anyways. Just follow the instructions for each platform.

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
   * wget
   * tree
3. After finishing all, it starts installing my minimum required apps:
   * Google Chrome
   * LaunchBar
   * iTerm2
   * Speed Download Lite
4. After above packages are installed, it tries to setup the user's home directory:
   * Downloads and configures my [**Vim**-vironment](http://github.com/isa/vim-vironment)
   * Creates all the symbolic links necessary to work with anything (.profile, .git-config, .hgrc, etc)

### Ubuntu

Coming soon..

### Windows

Coming soon..

## What's Next?

Well, there are couple more steps for you to be ready.

First let's make your **Vim** awesome. Just launch vim and type:

    :BundleInstall

This will setup your vim plugins.

## Done?

For now, but you can always add more confgiuration any time. The idea is just making things easier. This works for me, and I'm not intending to replace any of the devops solutions out there. This is not a devops tool. This is just a bunch of scripts that speeds up machine setup.

Hope you like it.
