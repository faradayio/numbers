---
title: We are an XML web service, too
author: Seamus
layout: post
categories: technology
---

You can talk to Carbon Middleware in XML:

{% highlight console %}
$ curl -v http://carbon.brighterplanet.com/automobiles.xml \
       -H 'Content-Type: application/xml' \
       -X POST \
       --data "<make>Nissan</make>"
{% endhighlight %}

You can receive responses in XML:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <emission type="float">4017.7826406033573</emission>
  <emission-units>kilograms</emission-units>
  <make>
    <fuel-efficiency type="float">11.7886</fuel-efficiency>
    <fuel-efficiency-units>kilometres_per_litre</fuel-efficiency-units>
    <name>Nissan</name>
  </make>
  <!-- [...] -->
</hash>
{% endhighlight %}

We're just trying to make it easy to connect with us, whether your application speaks XML, JSON, or even <tt>x-www-form-urlencoded</tt>.
