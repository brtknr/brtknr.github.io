---
layout: post
title: "Enabling MathJax on a Jekyll server when offline"
date: 2017-03-08T19:00:00+00:00
tags:
- LaTeX
- MathJax
- jekyll
- offline
---

I like MathJax. It does a great job displaying equations on web pages written using `$ \rm\LaTeX $`. However, I recently wrote a Jekyll [blog post][blog-post] which uses MathJax and tried to view it on a locally deployed server while commuting on a train journey with no Internet connection. Then, I realised that it did not render the equations at all because it relied on sending AJAX requests to a remote server. Something had to be done and this is how I went about fixing it.

First of all, I cloned MathJax from its [Github repository][mathjax] and placed it on a separate folder called `PathToMathJax/` outside the scope of this Jekyll site.

In `_config.yml`, I added a new variable called `mathjax_url` which contains the URL that Jekyll will use on the production site as below:

{{< highlight yaml >}}
mathjax_url: http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML
{{< /highlight >}}

Then, in order to override the production setting on the development server, I created a separate file called `_config-dev.yml` on the same folder containing the following:

{{< highlight yaml >}}
mathjax_url: http://localhost:4000/MathJax.js
{{< /highlight >}}

In `_layouts/header.html`, include the following line:

{{< highlight html >}}
<script type="text/javascript" src="{{ site.mathjax_url }}"></script>
{{< /highlight >}}

In order to automate deployment on the local server, I created a bash script called `serve.sh` with the following:

{{< highlight bash >}}
pushd PathToMathJax/; python -m SimpleHTTPServer & popd
jekyll serve --config _config.yml,_config-dev.yml
{{< /highlight >}}

As you can see, Jekyll uses the settings contained in `_config.yml` then overrides the settings with the content of `_config-dev.yml`. Now, simply execute `serve.sh` to watch everything work together like a clockwork. Hurrah!

[blog-post]:http://massevac.github.io/2015/03/10/how-well-does-population-distribution.html
[mathjax]:http://www.github.com/mathjax/MathJax
