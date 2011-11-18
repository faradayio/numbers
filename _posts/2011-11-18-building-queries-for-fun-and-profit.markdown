---
title: Building queries for fun and profit
author: Andy
layout: post
categories: technology
---

![Query builder screenshot](/images/query_builder.png)

The primary way to experiment with [CM1](http://impact.brighterplanet.com) is to hit the API directly---either with code, a tool like cURL, or with our [CM1 console](http://numbers.brighterplanet.com/2011/04/20/introducing-bombshell-custom-interactive-consoles-for-your-ruby-libraries). But sometimes it's just easier to play around in a browser, so today we're rolling out a Query Builder feature for each of our [impact models](http://impact.brighterplanet.com/models). Details after the jump.

<!-- more start -->

To get started, visit the details page for any of our [impact models](http://impact.brighterplanet.com/models)---you'll find the model's query builder at the bottom of its page.

On the left is where you build your request by adding, defining, and tweaking characteristics according to the model's API (click the "characteristics API" link on that same page for full details).

As you type, the query builder will continuously submit your request to CM1. Interpretations of your characteristics will display below the text fields, and the carbon impact will update on the right. In the lower right you'll find some useful representations of this query, including a human-readable methodology link and a copy-pastable cURL command.

Check out some pre-built queries by using the example dropdown in the upper-right. We'll be adding many more example queries over the coming week.

<!-- more end -->
