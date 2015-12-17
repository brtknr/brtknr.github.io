---
layout: post
title: 'Logging CPU temperature using crontab on OSX!'
date: '2017-12-17T15:16:00+00:00'
tags:
- temperature
- cron job
- crontab
- OSX
---
I have just set up a way to automatically log temperature using OSX terminal. Here is how I did it.

First of all, I installed [Temperature Monitor for OSX][tempmonitor] from this URL into the application folder.

Then I edited the crontab like this:

{% highlight bash %}
env EDITOR=nano crontab -e
{% endhighlight %}

In the editor, I entered the following line which creates and appends temperatures from your built-in sensors at a minute interval to a file called temp.txt on your desktop.

{% endhighlight %}
*       *       *       *       *       echo "$(date)\n$(/Applications/TemperatureMonitor.app/Contents/MacOS/tempmonitor -c -l -a)\n\n$(cat ~/Desktop/temp.txt)" > ~/Desktop/temp.txt
{% endhighlight %}

Press CTRL+X then ENTER to save the file. Then you're done! Wait for the file to be created on your desktop.

[tempmonitor]:http://www.bresink.eu/Downloads/TemperatureMonitor.dmg