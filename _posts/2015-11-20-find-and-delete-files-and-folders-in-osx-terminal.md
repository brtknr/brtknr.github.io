---
layout: post
title: 'Find and delete files and folders in OSX terminal'
date: '2015-11-20T10:54:00+00:00'
tags:
- osx
- terminal
- find
- delete
- files
- folders
---

Finding and deleting files and folders in OSX is simple. Open your terminal. In order to just find your files/folders (__non destructive__):

For files:

{% highlight bash %}
find . -name "Icon?" -type f
{% endhighlight %}

For folders:

{% highlight bash %}
find . -name "Icon?" -type d
{% endhighlight %}

For files and folders

{% highlight bash %}
find . -name "Icon?" -type f -o -name "Icon?" -type d
{% endhighlight %}

In order to delete them, just add `-delete` operator to the end (__DESTRUCTIVE__):

For files:

{% highlight bash %}
find . -name "Icon?" -type f -delete
{% endhighlight %}

For folders (although you may get a warning message saying 'No such file or directory'):

{% highlight bash %}
find . -name "Icon?" -type d -exec rm -rf {} \;
{% endhighlight %}

The `?` symbol after the filename is a wildcard for a single character. To enable more characters, use `*` instead.