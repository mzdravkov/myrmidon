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
make install cleane
```

Install git:  
```console
cd /usr/ports/devel/git  
make install clean
```

Install ruby:
```console
cd /usr/ports/lang/ruby19  
make install clean
```

