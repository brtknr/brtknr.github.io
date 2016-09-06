---
layout: post
title: 'Getting AIMSUN 8.1.3 to work on Ubuntu 16.04 (x64 build)'
date: '2016-09-05T19:54:00+00:00'
tags:
- aimsun
- TSS
- compatibility
---

After installing AIMSUN 8.1.3 on Ubuntu 16.04 (x64 build), when you try and run it through launcher, the icon would appear for a while and close without any indication of what the problem was. The problem was more obvious when starting up the AIMSUN through terminal where I got a message saying:

`Aimsun: error while loading shared libraries: libvpx.so.1: cannot open shared object file: No such file or directory`

This was resolved by downloading version [1.3.0-3][1.3.0-3] of [libvpx][libvpx]. To install, run the following dpkg command on terminal:

`sudo dpkg -i libvpx1_1.3.0-3ubuntu1_amd64.deb`

AIMSUN should run without any issues now. Let's all enjoy this cool video of an intersection somewhere:

# Awesome video of intersection
<iframe width="560" height="315" src="https://www.youtube.com/watch?v=ufK2XRGUjuc" frameborder="0" allowfullscreen></iframe>

[libvpx]:(https://launchpad.net/ubuntu/%2Bsource/libvpx)
[1.3.0-3]:(https://launchpad.net/ubuntu/+archive/primary/+files/libvpx1_1.3.0-3ubuntu1_amd64.deb)
