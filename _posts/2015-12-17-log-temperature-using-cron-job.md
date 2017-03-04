---
layout: post
title: 'Use crontab to log CPU temperature on OSX!'
date: '2015-12-17T15:16:00+00:00'
tags:
- temperature
- cron job
- crontab
- OSX
---
I have just set up a way to automatically log temperature using OSX terminal because my computer was frequently overheating and I wanted to investigate why. Here is breakdown of how I did it.

First of all, I installed [Temperature Monitor for OSX][TemperatureMonitor] from this URL into the application folder.

On terminal, I entered the following command to edit crontab using nano environment.

	env EDITOR=nano crontab -e

In the editor, I entered the following line which creates and appends date, time and  temperatures from all your built-in sensors at a minute interval to ~/Desktop/temp.txt. Feel free to change this to whatever you like.

	*       *       *       *       *       date >> ~/Desktop/temp.txt && /Applications/TemperatureMonitor.app/Contents/MacOS/tempmonitor -c -l -a >> ~/Desktop/temp.txt


Press CTRL+X, letter 'Yes' then ENTER to save the file. Then you're done! Wait for the file to be created on your desktop.

To filter the DIODE temperatures, simply enter the following command into the terminal.

	cat ~/Desktop/temp.txt | grep 'DIODE'

The latest temperature is shown at the bottom.

[TemperatureMonitor]:http://www.bresink.eu/Downloads/TemperatureMonitor.dmg