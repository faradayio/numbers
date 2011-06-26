---
title: The wonderful convenience of Earth
author: Andy
layout: post
categories: technology
---

When I was whipping up [Yaktrak](http://yaktrak.org) I needed to get a (richly annotated) list of zip codes into the app. This is a familiar problem for web app developers: what's the easiest way to get auxiliary data from canonical sources loaded and ready to use?

<!-- more start -->

Lucky for me we have [`earth`](http://github.com/brighterplanet/earth). Look at how easy this is:

{% highlight console %}
$ rails new zippy
{% endhighlight %}

In the Gemfile:
{% highlight ruby %}
gem 'earth'
gem 'fastercsv' # not needed if using Ruby 1.9
{% endhighlight %}

And in `config/environment.rb` or an initializer:
{% highlight ruby %}
Earth.init 'locality/zip_code'
{% endhighlight %}

Back at the shell:
{% highlight console %}
$ bundle install
$ rails console
{% endhighlight %}
{% highlight rbcon %}
irb(main):001:0> ZipCode.run_data_miner!
Schema:        100% |==========================================| Time: 00:00:05
zip_codes:     100% |==========================================| Time: 00:06:48
irb(main):002:0> ZipCode.find '53704'
 => #<ZipCode name: "53704", state_postal_abbreviation: "WI", description: "Madison", latitude: "43.121416", longitude: "-89.34968", egrid_subregion_abbreviation: "MROE", climate_division_name: "WI8", created_at: "2010-05-14 22:57:57", updated_at: "2010-05-14 23:03:27">
{% endhighlight %}

Voila! Fresh from the [transparent data crawlers](http://data.brighterplanet.com/zip_codes) at [data.brighterplanet.com](http://data.brighterplanet.com).

<!-- more end -->
