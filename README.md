#Myrmidon

##About
Myrmidon is an application for deploying and managing web applications.

The goals of Myrmidon are:

* easy deploying of web applications written in any language, by making "copies" of one template application. Each new deployed application is called a tenant in the Myrmidon world.
* configuration of the deploying process (Myrmidon uses nginx).
* configuration of the tenants.
* managing plugins of the tenants.

Beware, here be dragons!

* Giving to users the ability to write their own plugins for their sites, which are running on the Myrmidon host.

Myrmidon is created with the very idea to be used with a CMS (Content Management System) application. Althought this is not a requirement, it will be a really powerful combination. The result of mixing Myrmidon with a CMS application will be something similar to wordpress.com. Every user will be able to create it's own website, configure it and use it without any technical knowledge. And programmers will be able to create plugins for their tenants, without having to download any code, deal with hosting, registering a domain name, etc. If creating and deploying CMSes is so easy, maybe people will end up having many domain specific CMSes, instead of one or two, that deals with everything.

##How it works

Myrmidon is a rails application with some other components, which all together create one system for creating, deploying and managing web applications.

### The Rails application
The Rails application works as a front end of the Myrmidon system. It gives web interface for user registration, creation of tenants, managing existing tenants and etc. The Rails application is controlling the other parts of the system, so you can think of it, as the core of the system.

### Docker

Myrmidon uses [Docker](http://docker.io) for separating applications in an isolated environment. If you don't know anything about Docker and how it works, you may want to visit their website and read about it - you may find it interesting and it is really the base of how Myrmidon works. Understanding Docker will really help you understanding Myrmidon.

With few words (if you are too lazy to researh it): "Docker is an open-source engine that automates the deployment of any application as a lightweight, portable, self-sufficient container that will run virtually anywhere."

So any web application, written in any language, can be put with all it's dependencies in a docker image and Myrmidon can deploy it.

### Nginx

Myrmidon uses Nginx as it's web server. Request to the Myrmidon's host will be catched by Nginx and routed to either Myrmidon (the rails app) or some of the deployed tenants.

####WARNING!
Myrmidon is in very early state of development and it's not really usable for the moment.

##Installation

Get Myrmidon:  
```console
git clone https://github.com/mzdravkov/myrmidon
```

Install passenger:  
```console
gem install passenger
```

Then run the passenger-nginx installation:  
```console
passenger-install-nginx-module
```

When asked where to install nginx, you should (it's recommended) enter ```/myr/nginx```.

There is an example ```nginx.conf``` in ```examples/```. Be sure to have those 4 lines from it:
```passenger_user_switching off;```  
```passenger_default_user myrmidon;```  
```passenger_default_group myrmidon;```  
```passenger_user myrmidon;```

Install Docker: [Instructions here](http://www.docker.io/gettingstarted/#h_installation).

Create a ```docker``` group as shown [here](http://docs.docker.io/en/latest/use/basics/#sudo-and-the-docker-group).

Create an user called ```myrmidon``` (if you want to use a different name, make sure to change the name in your nginx.conf) and add him to the ```docker``` group.


You have to allow your ```myrmidon``` user to be able to run ```sudo``` commands without password.
On Debian/Ubuntu (and maybe all Linux distributions) you have to add this line to ```/etc/sudoers```:

```myrmidon ALL=NOPASSWD: ALL```

#####WARNING!!! MAKE SURE TO USE VISUDO, OTHERWISE YOU CAN SCREW UP YOUR OS.

Make sure all the things Myrmidon will need are not write protected:  
```sudo chown -R myrmidon:myrmidon /myr```

Note that if you add as ```root``` new files to the ```/myr``` directory after you have changed it's ownership, the new files will still belong to ```root``` so you have to run ```chown``` again or just make new files in ```/myr``` as ```myrmidon```.


####If you want to use Myrmidon to configure the tenants

Make ```mkdir /myr/configs``` and ```/myr/tenant_conf.default.yml```. (those like a lot of other things, can be changed in the config/application.yml file) In the second you put the default configuration for your tenants like this:

```name_of_the_configuration:```  
```__type: int/string/bool```  
```__category: some_category```  
```__value: default_value```  

NOTE: __ is two spaces... I just can't make this markdown to indent two spaces!
