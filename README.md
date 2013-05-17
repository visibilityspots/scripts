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

spamcop.sh
----------

I'm using procmail which filters out incoming spam gathered by fetchmail to some maildir directories. This procmail configuration will also check the incoming mail for spam using spamassissin and moving the malfious message to a predefined spam maildir.

Using this script you will be able to report those spam messages to the www.spamcop.net service using mutt, learn the message to your local spamassassin bayes client and removing it from the spam maildir.

An hourly cron job which runs this script every hour even makes it fully automagically.

If you use a muttrc file on a custom place replace the mutt command to:
	
	echo "Reporting spam" | mutt -F ~/.custom/path/to/muttrc -s "Reporting suspicious mail" $REPORTADDRESS -a $SPAMMESSAGE

fnotify.sh
----------

I'm using an irssi/bitlbee setup on a remote server using screen for instant messaging services. But that terminal doesn't always have my focus. Therefore I use the fnotify irssi plugin which will report all messages directly addressed to me in a file on that remote server.

Using this script on my local machine it will connect to that remote server using ssh and alerting the messages from that remotely file on my local machine. You can use different notifiers commands depending on your used window manager.

setsmtp.sh
----------

I'm using msmtp on my local machine for sending mails using mutt. Depending on my network connection this server can defer. Because I don't wanted to rewrite every time I'm on a different location my muttrc configuration I wrote this script which will points to the right msmtp configuration (https://wiki.archlinux.org/index.php/Msmtp).

You can also write a script which will sets your msmtp server depending on your network connection parameters and call that script on startup.

hubot
-----

A init script for hubot on a CentOS machine based on the one from linickx (https://gist.github.com/linickx/3692156). Place the hubot file to /etc/init.d/hubot and adapt the parameters to your preferences:

DAEMON="bin/hubot"
ROOT_DIR="/opt/hubot"
DAEMON_ADAPTER="irc"
LOG_FILE="/var/log/hubot.log"
USER=hubot

I also wrote a puppet-hubot module which automatically deploys this script (https://github.com/visibilityspots/puppet-hubot)

hubot-script.sh
---------------

I deployed a hubot for an IRC channel. The default features were not sufficient so I installed some plugins from https://github.com/github/hubot-scripts. Thing is, it's quite a lot of work, declaring the dependencies, adding the plugin specific parameters, updating the npm environment...

So I wrote this script. Just copy it into your hubot root dir (/opt/hubot/ for example) and run it using ./plugin-hubot NAMEOFTHESCRIPT. Just the name of the script is sufficient, you don't have to specify the .coffee extension. 

conky-tracks.sh
---------------

In my conky-colors setup I integrated my todo tasklist. The conky configuration will call this script and read out the stripped out tasklist file. Soon I will write a blogpost about my conky setup with the full configuration file.
