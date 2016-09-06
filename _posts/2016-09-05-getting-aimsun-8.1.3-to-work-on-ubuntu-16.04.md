---
layout: post
title: 'Getting Aimsun 8.1.3 to work on Ubuntu 16.04'
date: '2016-09-05T19:54:00+00:00'
tags:
- aimsun
- TSS
- compatibility
---

After installing TSS's Aimsun 8.1.3 on Ubuntu 16.04 (x64 build) on my machine, I tried to launch the program. However, the icon would appear briefly and close without any indication of what the problem was. The problem became obvious when starting up Aimsun through terminal using `$ /opt/Aimsun_8_3_0/Aimsun` when I got a message saying:

>	Aimsun: error while loading shared libraries: libvpx.so.1: cannot open shared object file: No such file or directory`

This was resolved by downloading version [1.3.0-3][1.3.0-3] of [libvpx][libvpx]. To install, run the following dpkg command on terminal:

`sudo dpkg -i libvpx1_1.3.0-3ubuntu1_amd64.deb`

Now that Aimsun is fixed, let's all enjoy this cool video of an intersection:

<iframe width="560" height="315" src="https://www.youtube.com/embed/ufK2XRGUjuc" frameborder="0" allowfullscreen></iframe>

[libvpx]:(https://launchpad.net/ubuntu/%2Bsource/libvpx)
[1.3.0-3]:(https://launchpad.net/ubuntu/+archive/primary/+files/libvpx1_1.3.0-3ubuntu1_amd64.deb)
