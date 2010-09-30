---
title: Ruby 1.9.2 Marshal.dump remembers string encoding
author: Seamus
layout: post
categories: [technology]
---

Ruby 1.9.2 remembers encoding when it marshals a string:

{% highlight ruby %}
ruby-1.9.2-p0 > Marshal.dump('hi')
 => "\x04\bI\"\ahi\x06:\x06ET" 
ruby-1.9.2-p0 > require 'iconv'
=> true 
ruby-1.9.2-p0 > Marshal.dump(Iconv.conv('US-ASCII', 'UTF8', 'hi'))
=> "\x04\bI\"\ahi\x06:\x06EF" 
{% endhighlight %}

Ruby 1.8 did not:

{% highlight ruby %}
ruby-1.8.7-head > Marshal.dump('hi')
 => "\004\b\"\ahi" 
ruby-1.8.7-head > require 'iconv'
 => true 
ruby-1.8.7-head > Marshal.dump(Iconv.conv('US-ASCII', 'UTF8', 'hi'))
 => "\004\b\"\ahi" 
{% endhighlight %}
