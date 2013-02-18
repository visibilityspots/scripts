Scripts
=============

Scripts I wrote or adopted to make my life easier. 

Stored in a .scripts direcoty and created symlinks for into /usr/bin/ (sudo ln -s ~/.scripts /usr/bin/symlinkname) so those commands can be easily used in terminal modus.

Feel free to adopt, change and create issues for them.

icinga.sh
---------

This script can be used to display the output of icinga on your desktop conky setup. 

Usage in conkyrc configfile:

  ${execpi 53 ~/.conky/icinga.sh}

encryptation.sh
---------------

This script I use to decrypt multipe dropbox accounts using encfs for work related data, personal data and evolution data.

More information can be found on http://www.visibilityspots.com/dropbox/

shares.sh
---------

I use a network share on an iomega boxee device as a central place for all my data (pictures, movies, music and random data)

To easily mount and umount those shares I wrote this script.                                                                                 

crashplan.sh
------------

I'm running an headless crashplan instance on a CentOS server. To have the crashplan Desktop engine working with this setup you have to change the servicePort in the ui.properties file from crashplan and setting up an ssh tunnel through the server.

Using this script I managed to change the ui.properties to switch easily between the server client and the local client.
