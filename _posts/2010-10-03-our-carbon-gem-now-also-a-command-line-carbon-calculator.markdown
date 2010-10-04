---
title: Our carbon gem is now also a command-line carbon calculator
author: Andy
layout: post
categories: middleware science
---

Version 0.3.0 of the [`carbon` gem](http://github.com/brighterplanet/carbon)---our Ruby wrapper for the [emission estimates service](http://carbon.brighterplanet.com) API---includes "command-line access" to the web service:

{% highlight ruby %}
# `carbon`
carbon-> key '123ABC'
  => Using key 123ABC
carbon-> flight
  => 1210.66889895298 kg CO2e
flight*> origin_airport 'lax'
  => 1461.63846640404 kg CO2e
flight*> destination_airport 'jfk'
  => 1733.79410872608 kg CO2e
flight*> url
  => http://carbon.brighterplanet.com/flights.json?origin_airport=lax&destination_airport=jfk&key=123ABC
flight*> done
  => Saved as flight #0
carbon-> exit
{% endhighlight %}

(Notice that you'll need a [developer key](http://keys.brighterplanet.com) to use this or any other Carbon Middleware-powered library.)

We think this feature might be especially useful to researchers and scientists who want to make "quick" calculations but still want to rely on our rigorous, transparent [carbon models](http://carbon.brighterplanet.com/models).

For complete documentation see the [README](http://github.com/brighterplanet/carbon#readme).

Go ahead and give it a try!

{% highlight console %}
$ gem install carbon
$ carbon
carbon->
{% endhighlight %}
