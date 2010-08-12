---
title: Stealing service
author: Seamus
layout: post
categories: [science, middleware]
---

### The technical details

(Note: if you are a non-technical reader, you can skip this section. I basically describe how you can exploit the nature of web services to get emission estimates for free.)

When I was working on [improving web service availability using Amazon AWS as an alternate input and output channel](http://numbers.brighterplanet.com/2010/08/11/use-amazon-sqs-to-get-emission-estimates), Andy pointed out that I was making it very easy to "rainbow table" Brighter Planet emission estimates. You just scrape the [possible input values](http://carbon.brighterplanet.com/use), come up with a <tt>guid</tt> scheme

    guid=automobile-Nissan-3000_miles_per_year

and then translate any client's specific request into something that's already been calculated (read: charged) and stored. You would have constructed a private lookup table of all possible estimates&mdash;and heck, Brighter Planet would even be paying to store it for you on Amazon S3!

### Why would you ever mention this?

Why would I explain a technical approach to stealing Brighter Planet's services? Well, because you wouldn't really be stealing at all.

### Science-as-a-service cannot be stolen

I'm confident that we can be transparent about technical possibilities like this because you can't fake good science. Day in and day out, Brighter Planet's science team is [curating the latest data](http://data.brighterplanet.com), fact-checking our [best-in-class estimation algorithms](http://github.com/brighterplanet/sniff), and calling on our networks ([formal](http://brighterplanet.com/about/advisory_board) and informal) of climate-change experts.

With the approach I described above, you would effectively be caching whatever the state-of-the-art was of climate science on the day the query was first run. It will evolve over time and unless you re-run the estimate, you would be using "old science." (There are valid uses for this! For example, you might want to re-run an estimate at most once a week.)

The fundamental value we provide our clients, scientific expertise, cannot be stolen, no matter how convenient it is to access.
