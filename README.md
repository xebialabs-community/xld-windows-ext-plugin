#XL Deploy Windows Extension Plugin#

##Introduction:##
The XL Deploy Windows Extension Plugin creates some extensions on the existing Windows Plugin.  Specifically for Windows shops that are building their own Windows Services the deployables in this plugin allow for the installation of these services and service activation.

##Using the deployables and deployeds##

###Deployable vs Container table###

The following table describes which deployable/container combinations are possible:

|         Deployable        |   Container    |  Generated deployed   |
|---------------------------|----------------|-----------------------|
| windows.dotnetServiceSpec | overthere.Host | windows.dotnetService |
| windows.deployServiceSpec | overthere.Host | windows.deployService |

