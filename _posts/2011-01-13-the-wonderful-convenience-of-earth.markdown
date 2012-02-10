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
gem 'fastercsv' # only if you're on Ruby 1.8
{% endhighlight %}

And in `config/environment.rb` or an initializer:
{% highlight ruby %}
Earth.init :locality
{% endhighlight %}

Back at the shell:
{% highlight console %}
$ bundle install
$ rails console
{% endhighlight %}
{% highlight rbcon %}
1.9.3-p0 :001 > ZipCode.run_data_miner!
   (7.2ms)  DROP TABLE "zip_codes"
Receiving schema
Schema:          0% |                                          | ETA:  --:--:--
Schema:        100% |==========================================| Time: 00:00:01
Receiving indexes
Receiving data
1 tables, 200 records
zip_codes:     100% |==========================================| Time: 00:00:09
Resetting sequences
[...it will also add some related tables...]
1.9.3-p0 :002 > ZipCode.find 53703
  ZipCode Load (22.4ms)  SELECT "zip_codes".* FROM "zip_codes" WHERE "zip_codes"."name" = ? LIMIT 1  [["name", 53703]]
 => #<ZipCode name: "53703", state_postal_abbreviation: "WI", description: "Madison", latitude: "43.078646", longitude: "-89.37727", egrid_subregion_abbreviation: "MROE", climate_division_name: "WI8">
{% endhighlight %}

Voila! Fresh from the [transparent data crawlers](http://data.brighterplanet.com/zip_codes) at [data.brighterplanet.com](http://data.brighterplanet.com).

<!-- more end -->
