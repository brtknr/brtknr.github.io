---
layout: post
title: "Permission issues with `xpra 0.15.x` on Ubuntu 16.04 Xenial when tunnelling through SSH"
date: 2017-03-15T19:00:00+00:00
tags:
- SSH
- xpra
- Ubuntu 16.04 Xenial
---

I often log into a remote SSH terminal to use an `ipython` shell. In doing so, it is necessary for me look at figures invoked by `matplotlib` as I am exploring and analysing data. For this, I have comfortably been using a combination of `screen` and `xpra`. However, I recently hesitantly upgraded my Ubuntu distribution from 14.04 Trusty Tahr to 16.04 Xenial Xerus. And with all upgrades, I expected minor breakages. Little did I realise that it would break `xpra` and interrupt my workflow sending me down a rabbit hole internet trawling for solutions. Turns out it is a known [issue] on on launchpad but the discussion has not been active for a while and the provided solutions were incomprehensible to a lay user. It appears that simply updating `xpra` to the latest version resolves the issue.

# TL;DR

Log into the report server:

{% highlight bash %}
ssh -Y username@remote
{% endhighlight %}

On the remote server, update to the latest stable release of `xpra` which at the time of writing this was `2.0-r15319-1`. The update [instructions] which were not so obvious to find are as follows: 

{% highlight bash %}
# Administrator privileges
sudo su -
# Import the packager's key:
apt-get install curl
curl http://winswitch.org/gpg.asc | apt-key add -
# Xenial Xerus (16.04)
echo "deb http://winswitch.org/ xenial main" > /etc/apt/sources.list.d/winswitch.list;
apt-get install software-properties-common >& /dev/null;
add-apt-repository universe >& /dev/null;
apt-get update;
apt-get install winswitch
{% endhighlight %}

Now start an `xpra` server and attach to the session inside a `screen` session:

{% highlight bash %}
xpra start :10
xpra attach :10
{% endhighlight %}

Press `Ctrl+a, d` to detach from the screen session. Now run the following on a separate `screen` session which should launch a beautiful empty plot on your client.

{% highlight bash %}
DISPLAY=:10 ipython --pylab -c 'plot()'
{% endhighlight %}

# The rabbit-hole journal

To replicate the problem on a vanilla installation of Ubuntu 16.04 with the default installation of `xpra` version `0.15.8+dfsg-1 amd64` at the time of writing this blog:

{% highlight bash %}
ssh -Y username@remote
xpra start :10
{% endhighlight %}

I tried to create a `plot()` as usual in `ipython` shell with `pylab` module using the default `Qt4Agg` backend:

{% highlight bash %}
DISPLAY=:10 ipython --pylab -c 'plot()'
{% endhighlight %}

Which generated the following error:

>    : cannot connect to X server :10

I inspected the content of my log by running `cat ~/.xpra/:10.log`:

>   /usr/lib/xorg/Xorg.wrap: Only console users are allowed to run the X server
>   2017-03-15 15:03:37,413 
>   2017-03-15 15:03:37,413 Xvfb command has terminated! xpra cannot continue
>   2017-03-15 15:03:37,413 

I found these [discussions] to change `allowed_user=console` to `allowed_users=anybody` by running `sudo dpkg-reconfigure xserver-xorg-legacy` for a GUI interface or alternatively by running the following `sed` command on `bash`:

{% highlight bash %}
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
{% endhighlight %}

Now when I ran `xpra start :10`, noticed that my `plot() function still was not working`. I inspected the log using `cat ~/.xpra/:10.log` again and saw the following:

>   ~/.xpra/IT050339-10 is not responding, waiting for it to timeout before clearing it.(EE) 
>   Fatal server error:
>   (EE) The '-logfile' option cannot be used with elevated privileges.
>   (EE) 
>   (EE) 
>   Please consult the The X.Org Foundation support 
>            at http://wiki.x.org
>    for help. 
>   (EE) 
>   ....
>   2017-03-15 13:15:38,963 
>   2017-03-15 13:15:38,963 Xvfb command has terminated! xpra cannot continue
>   2017-03-15 13:15:38,963 
>   2017-03-15 13:15:38,963 removing socket /home/bk12369/.xpra/IT050339-10

I thought I would try launching `xpra` as a superuser so I ran `sudo xpra start :10`. When I inspected the log this time using `cat ~/.xpra/:10.log`, this is what I saw:

>   X.Org X Server 1.18.4
>   Release Date: 2016-07-19
>   X Protocol Version 11, Revision 0
>   Build Operating System: Linux 4.4.0-45-generic x86_64 Ubuntu
>   Current Operating System: Linux IT050339 4.4.0-66-generic #87-Ubuntu SMP Fri Mar 3 15:29:05 UTC 2017 x86_64
>   Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.4.0-66-generic root=UUID=51981f04-c04d-4b55-a28d-31f545fa32b7 ro quiet splash
>   Build Date: 02 November 2016  10:06:10PM
>   xorg-server 2:1.18.4-0ubuntu0.2 (For technical support please see http://www.ubuntu.com/support) 
>   Current version of pixman: 0.33.6
>           Before reporting problems, check http://wiki.x.org
>           to make sure that you have the latest version.
>   Markers: (--) probed, (**) from config file, (==) default setting,
>           (++) from command line, (!!) notice, (II) informational,
>           (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
>   (++) Log file: "/home/bk12369/.xpra/Xorg.:10.log", Time: Wed Mar 15 15:30:37 2017
>   (++) Using config file: "/etc/xpra/xorg.conf"
>   (==) Using system config directory "/usr/share/X11/xorg.conf.d"

This was what I initially expected to see but when I ran `DISPLAY=:10 ipython --pylab -c 'plot()`, it still refused to work by producing the following error:

>   No protocol specified
>    : cannot connect to X server :10

Note that this is slightly different to earlier since it recognises that there is an open port but still struggling to connect. Next, I found that changing the permission for `~/.Xauthority` enabled me to query all the current sessions as follows:

{% highlight bash %}
sudo chown $USER:$USER ~/.Xauthority
xauth list | grep `uname -n`
{% endhighlight %}

Which returned:

>	IT050339/unix:10  MIT-MAGIC-COOKIE-1  e65eee56adec473c9a04c74e2089f8b7

This allowed me to run `DISPLAY=:10 ipython --pylab -c 'plot()` without any errors. However, I was still unable to attach to the session using `xpra attach :10`.

This is when I decided to update `xpra` to the latest branch as per the instructions provided in [TL;DR](#tldr) which took a great difficulty to find which resolved everything.

## Lesson learnt

Persevere and keep trying new things.

[instructions]: http://winswitch.org/downloads/debian-repository.html?dist_select=xenial
[issue]: https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-dummy/+bug/1589447
[discussions]: http://unix.stackexchange.com/questions/153870/how-can-i-configure-anybody-to-run-x-in-a-one-liner
