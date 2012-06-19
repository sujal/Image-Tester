# Image Tester

A simple project that shows loading time differences between progressive
jpgs & regular jpgs in a vanilla UIImageView

----

While testing a performance issue with one of our applications, I found
this peculiar behavior: loading a JPG from our server took around 2
seconds to render onto the screen.

As I looked into it, this time was CPU time decoding the actual JPEG
file. Oddly enough, once the same image is saved to the camera roll, it
loads quickly.

The primary difference between the two images was that Photos.app
converted the image from a progressive JPEG to a baseline JPEG. 

This document explains some reasons why this might matter:

http://duncandavidson.com/blog/2012/03/retina_web_thoughts

anyway, this is a test harness that I created to test the performance.
I'm going to point at it for some stack overflow questions or whatever.

Let it stand as a monument to this investigation. Or something.

---- 

Code is public domain. Rock it however you want. Specifically, it's 
offered up under terms of CC0:
http://creativecommons.org/publicdomain/zero/1.0/

