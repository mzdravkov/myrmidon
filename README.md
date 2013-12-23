#Projo

"Projo" is just a working name - most likely it will be changed.

###About
Projo is a rails app that spawns it's brave minions (rack apps) and runs them with nginx and passanger!
Basically, Projo is the deploying part of a CMS system me and friend of mine (d0ivanov) are writting as our thesis project.

The goals of projo are:

* easy deploying of rack applications (projo clones from one "source" application for each "tenant")
* easy configuration of the deploying process (projo uses nginx)
* configuration of the "tenants"
* managin plugins of the "tenants"

Beware, here be dragons!

* letting users write their own plugins, which are running on our host (unlike wordpress for example). This will be done using freeBSD jails, and other cool things.
(in some point of time, projo may be ported to linux)

Not really usable for the moment.
But still it's awesome!

### Install

Projo is currently depending on FreeBSD jails, so for the moment it can only run in FreeBSD. At some point in time, there may be a Linux port.  
It is being developed on FreeBSD 9.2, so this is the recommended version.

(This guide will install packages from source. You can install precompiled binaries for the dependencies, this way it will be faster.)

First you will need ezjail:  
```console
cd /usr/ports/sysutils/ezjail  
make install clean  
```

Install git:  
```console
cd /usr/ports/devel/git  
make install clean  
```

Install curl:  
```console
cd /usr/ports/ftp/curl  
make install clean  
```

Install bash if you don't have it:  
```console
cd /usr/ports/shells/bash  
make install clean  
```

###TODO:REMOVE THIS
Install ruby:  
```console
cd /usr/ports/lang/ruby19  
make install clean  
```
You will need sudo for installing rubies:  
```console
cd /usr/ports/security/sudo  
make install clean  
```

Make user for rvm:  
```console
adduser  

Username: rvm  
Full name: Ruby Version Manager  
Uid (Leave empty for default):  
Login group [rvm]:  
Login group is rvm. Invite rvm into other groups? []:  
Login class [default]:  
Shell (sh csh tcsh bash rbash nologin) [sh]: bash  
Home directory [/home/rvm]:  
Home directory permissions (Leave empty for default):  
Use password-based authentication? [yes]: no  
Lock out the account after creation? [no]: no  
Username   : rvm  
Password   :  
Full Name  : Ruby Version Manager  
Uid        : 1001  
Class      :  
Groups     : rvm  
Home       : /home/rvm  
Home Mode  :  
Shell      : /usr/local/bin/bash  
Locked     : no  
OK? (yes/no): yes  
adduser: INFO: Successfully added (rvm) to the user database.  
```

```console
su rvm  
```

Install RVM:  
```console
\curl -sSL https://get.rvm.io | bash -s stable  

Load RVM in bash:  
```console
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile  
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc  
source ~/.bash_profile
```
To check if everything with RVM is alrgiht:  
```console
type rvm | head -1
```
Should print 'rvm is a function'

Install ruby
```console
rvm install 1.9.3
```
You can check it with 'ruby -v'
