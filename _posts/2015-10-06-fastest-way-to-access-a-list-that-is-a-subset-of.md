---
layout: post
title: Fastest way to access a list that is a subset of an even bigger list
date: '2015-10-06T10:13:14+01:00'
tags:
- abm
- python
- cpu performance
- agent based modelling
tumblr_url: http://massevac.org/post/130617395901/fastest-way-to-access-a-list-that-is-a-subset-of
---
Say I have a list of objects called **agents** with 100,000 objects.

I have a second list called **agents_per_step** which refers to 39,393 objects in **agents**.

Say I need to access the agents in the reference list. What is the fastest way to access these objects?

I ran three tests:

1. Loop through a list directly containing the reference objects in **agents**
2. Loop through list of indices to access a *list* of **agents**
3. Loop through list of indices to access a *dict* of **agents**
 
I present the results below:

![Timeit results][timeit]

Turns out the winner is Method 1. Can anyone think of ways to make it faster?

[timeit]:{{site.url}}/images/timeit.png