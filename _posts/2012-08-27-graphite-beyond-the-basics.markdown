---
title: Graphite and statsd: Beyond the Basics
author: derek
layout: post
categories: technology
---

The [Graphite](http://graphite.wikidot.com/) and [statsd](http://github.com/etsy/statsd) systems have been [popular](http://codeascraft.etsy.com/2011/02/15/measure-anything-measure-everything/) choices lately for recording system statistics, but there isn't much written beyond how to get the basic system set up. Here are a few tips that will make your life easier.

<!-- more start -->

### Graphite + statsd - the rundown

The graphite and statsd [system](http://www.aosabook.org/en/graphite.html) consists of three main applications

* carbon: a service that receives and stores statistics
* statsd: a node server that provides an easier and more performant, UDP-based protocol for receiving stats which are passed off to carbon
* graphite: a web app that creates graphs out of the statistics recorded by carbon

### Use graphiti

[Several alternative front-ends](http://graphite.readthedocs.org/en/latest/tools.html) to graphite have been written. I chose to use graphiti because it had the most customizable graphs. Note that graphiti is just a facade on top of graphite - you still need the graphite web app running for it to work. Graphiti makes it easy to quickly create graphs. I'll cover this later.

The flow looks like:

    |App| ==[UDP]==> |statsd| ==> |carbon| ==> |.wsp file|

    |.wsp file| ==> |graphite| ==> |graphiti| ==> |pretty graphs on your dashboard|

### Use chef-solo to install it

If you're familiar with [chef](http://wiki.opscode.com/display/chef/Home), you can use the cookboos that the community has already developed for installing graphite and friends. If not, this would be a good opportunity to learn. You can use chef-solo to easily deploy graphite to a single server. I plan to write a "getting started with chef-solo" post soon, so stay tuned!

Chef saved me a ton of time setting up python, virtualenv, graphite, carbon, whisper, statsd, and many other tools since there are no OS-specific packages for some of these.

### Use sensible storage schemas

The default chef setup of graphite stores all stats with the following storage schema rule:

    [catchall]
    priority = 0
    pattern = ^.*
    retentions = 60:100800,900:63000

The retentions setting is the most important. It's a comma-delimited list of data resolutions and amounts.
* The number before the colon is the size of the bucket that holds data in seconds. A value of 60 means that 60 seconds worth of data is grouped together in the bucket. A larger number means the data is less granular, but more space efficient.
* The number after the colon is the number of data buckets to store at that granularity. 100800 will cover (100800 * 60) = 70 days of data. That's (100800 * 12) = 1.2MiB of space for those 70 days. A bigger number means more disk space and longer seek times.

Alternatively, you can specify retentions using time format shortcuts. For example, 1m:7d means "store 7 days worth of 1-minute granular data."

### Use a good stats client

In the ruby world, there are two popular client libraries: [fozzie](http://rubygems.org/gems/fozzie) and [statsd-ruby](http://rubygems.org/gems/statsd-ruby). Both provide the standard operations like counting events, timing, and gauging values.

Fozzie differs in that it integrates with Rails or rack apps by adding a rack middleware that automatically tracks timing statistics for every path in your web app. This can save time, but it also has the downside of sending too much noise to your statsd server and can cause excessive disk space consumption unless you implement tight storage schema rules. It also adds a deep hierarchy of namespaces based on the client machine name, app name, and current environment. This can be an issue on heroku web apps where the machine name changes frequently.

If you want more control over your namespacing, statsd-ruby is the way to go. Otherwise, fozzie may be worth using for its added conveniences.

### Make sure you don't run out of disk space

Seriously, if you do run out of disk, the graphite (whisper) data files can become corrupted and force you to delete them and start over. I learned this the hard way :) Make sure your storage schemas are strict enough because each separate stat requires its own file that can be several megabytes in size.

### Use graphiti for building graphs and dashboards

Graphiti has a great interface for building graphs. You can even fork it and deploy your own custom version that fits your company's needs and/or style. It's a small rack app that uses redis to store graph and dashboard settings. There's even a chef cookbook for it!

When setting up graphiti, remember to set up a cron job to run `rake graphiti:metrics` periodically so that you can search for metric namespaces from graphiti.

### Use graphite's built-in functions for summarizing and calculating data

Graphite provides a wealth of [functions](http://graphite.readthedocs.org/en/1.0/functions.html) that run aggregate operations on data before it is graphed.

For example, let's say we're tracking hit counts on our app's home page. We're using several web servers for load balancing and our stats data is namespaced by server under `stats.my_app.server-a.production.home-page.hits` and `stats.my_app.server-b.production.home-page.hits`. If we told graphite to graph results for `stats.my_app.*.production.home-page.hits` we would get two graph lines -- one for server-a and one for server-b. To combine them into a single measurement, use the `sumSeries` function. You can then use the alias function to give it a friendlier display name like "Home page."

Graphiti has a peculiar way of specifying which function to use. In a normal series list, you have the following structure:

    "targets": [
      [
        "stats.my_app.*.production.home-page.hits",
        {}
      ]
    ]

The `{}` is an object used to specify the list of functions to apply, in order, on the series specified in the parent array. Each graphite function is specified as a key and its parameters as the value. A `true` value indicates the function needs no parameters and an array is provided if the function requires multiple parameters.

You'll notice in the function documentation that each function usually takes two initial arguments, a context and a series name. In graphiti, you won't need to specify those first two arguments.

Here's an example of sumSeries and alias used together. Note that the order matters!

    "targets": [
      [
        "stats.my_app.*.production.home-page.hits",
        {
          "sumSeries": true,
          "alias": "Homepage hits"
        }
      ]
    ]

### Different graph areaMode for different applications

While not well documented, graphite has a few options for displaying graph lines. By default, the "stacked" area mode stacks each measurement on top of each other into an area chart that combines multiple measurements that are uniquely shaded. This can be good for seeing grand totals. The blank option plots each measurement as a line on a line chart. This is preferable for comparing measurements.

### Different metrics for different events

Each stats recording method provided by statsd-ruby and fozzie has different behavior, which isn't well documented anywhere.

* `Stats.count` is the base method for sending a count of some event for a given instance. It's rarely used alone.
* `Stats.increment` and `Stats.decrement` will adjust a count of an event. It's useful for counting things like number of hits on a page, number of times an activity occurs, etc. It will be graphed as "average number of events per second". So if your web app runs `Stats.increment 'hits'` 8 times over a 1 second period, the graph will draw a value of 8 for that second. Sometimes you will see fractional numbers charted. This is because graphite may average the data over a time period based on your schema storage settings and charting resolution.
* `Stats.timing` will take a block and store the amount of time the code in the block took to execute. It also keeps track of average, min, and max times, as well as standard deviation and total number of occurrences. 
* `Stats.gauge` tracks absolute values over time. This is useful for tracking measurements like CPU, memory, and disk usage.
* Fozzie provides `Stats.event 'party'` to track when an event happens. This is useful for tracking things like deploys or restarts. Equivalent functionality can be obtained in statsd-ruby by running `Stats.count 'party', Time.now.to_i`.

### Bonus tip: Graphs on your Mac dashboard

If you're using a mac, you can add your favorite graphs to your dashboard. Create a graph in graphiti, then view it on the graphiti dashboard with Safari. Click File->Open in Dashboard... and select the graph image with the select box. Now, you can quickly see important graphs at the press of a button!

Overall, statsd is a great tool and can add great visibility into your applications.

<!-- more end -->
