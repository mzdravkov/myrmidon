#Myrmidon


###About
Myrmidon is a rails application that spawns it's brave minions (rack applications) and runs them with nginx and passanger!  
Basically, Myrmidon is a software platform for easy building of Content Management Systems (CMS), like Wordpress, Tumblr and company.  
The main Idea is that if building a CMS is easy, people will create a lot of Domain Specific Content Management Systems. This will give to people the oppurtunity to create websites with tools created exactly for their website's domain. For example, if you want to create a website for video sharing, CMS that is created for making exactly that kind of websites will be a better fit, than just go with Wordpress or whatever else you like.

The goals of Myrmidon are:

* easy deploying of rack applications (Myrmidon clones from one "template" application for each "tenant")
* easy configuration of the deploying process (Myrmidon uses nginx)
* configuration of the "tenants"
* managing plugins of the "tenants"

Beware, here be dragons!

* letting users write their own plugins, which are running on our host (unlike Wordpress for example). This will be done using freeBSD jails, and other cool things.
(at some point of time, Myrmidon may be ported to linux)

For template application can be used every rack application, but if the application follows few "conventions" (like implementing a specific API for configurating the deployed application and API for managing plugins) it will be best. The first template application is being developped by d0ivanov [here](https://github.com/d0ivanov/videatra) and it is a video sharing application.

####WARNING!
Not really usable for the moment.
But still, it's *awesome!*

### Install

Myrmidon is currently depending on FreeBSD jails, so for the moment it can only run in FreeBSD. At some point in time, there may be a Linux port.  
It is being developed on FreeBSD 9.2, so this is the recommended version.  
The guide is tested on brand new FreeBSD v9.2, so this should be all the dependencies.

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

Install ruby:  
```console
cd /usr/ports/lang/ruby19  
make install clean  
```

Install ruby-gems port:  
```console
cd /usr/ports/devel/ruby-gems  
make install clean  
```

Install passenger gem, which we'll then use to install nginx:  
```console
gem install passenger  
```

It is recommended to build the whole system inside one directory. This way will be easier to maintain it.  
I like this approach, so it is the default:
```console
cd /  
mkdir /myr  
```
And everything for the platform will be kept inside _/myr/_. (for example we will have _/myr/nginx_ and _/myr/jails_)  

Install nginx:  
```console
passenger-install-nginx-module  
```
You will be greeted with some message and you will have to hit enter, then the installer will ask you what to do:  
```console
1. Yes: download, compile and install Nginx for me. (recommended)  
2. No: I wan to customize my Nginx installation. (for advanced users)  
```
Just choose 1 if you are not sure what to do.

```console
Where do you want to install Nginx to?
Please specify a prefix directory [/opt/nginx]: /myr/nginx
```
Altought you can decide to put it elsewere, it is recommended to put nginx there.
