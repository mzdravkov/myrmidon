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
