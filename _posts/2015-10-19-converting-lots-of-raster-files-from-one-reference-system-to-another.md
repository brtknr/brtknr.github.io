---
layout: post
title: "Converting lots of raster files from one reference system to another"
date: 2015-10-19T13:07:14+00:00
tags:
- raster
- gdalwarp
- gdal
- bash
---

I had to convert lots of OSGB EPSG:27700 raster files to LonLat EPSG:4326 format and here is how I did it on my OSX terminal. I also wanted to change the format from `*.asc` to `*.tif`. Supposing you already have `gdal` libraries installed, just run the following code:

{% highlight bash %}
input_folder = ???
output_folder=../LonLat

cd input_folder
mkdir output_folder

for file in *.asc; do
    gdalwarp -s_srs "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +towgs84=375,-111,431,0,0,0,0 +units=m +no_defs" -t_srs "+proj=longlat +datum=WGS84 +no_defs" "$file" "$folder/`basename $file .asc`.tif";
done
{% endhighlight %}

To utilise all CPUs, add `-wo NUM_THREADS=ALL_CPUS` to the `gdalwarp` options.

You can modify the for loop to rename lots of files. Here, I am rename them from `*.max` to `*.asc`.

{% highlight bash %}
for file in *.max; do
    mv "$file" "`basename $file .max`.asc";
done
{% endhighlight %}
