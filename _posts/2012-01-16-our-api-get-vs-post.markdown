---
title: Our API: GET vs POST
author: derek
layout: post
categories: technology
---

Today I had one of those moments where I thought we had implemented our API completely wrong. I'm the kind of person who hates it when someone breaks The Rules (especially when playing board games) and I freaked out about the thought of actually being someone who was *breaking* the rules of REST.

<!-- more start -->

As many web developers know, REST is the philosophy underlying HTTP. You send a GET request to a URI (e.g. `http://brighterplanet.com/about`) to get the HTML data identified by that URI. You send a POST request to `http://mystore.com/order` to create a new order for a product. In general, a GET request doesn't change the data behind the URI, but a POST will create data on the server.

Our [CM1](http://impact.brighterplanet.com) web service specifies that when you run a calculation, you POST to a model URI, e.g. `http://impact.brighterplanet.com/flights.json` with some parameters that tell us about the flight, like `airline=Delta`. In the past I had always thought of this as "creating a new calculation". However, as I thought about it more, I realized the POST isn't really changing any data on the server - it's not creating some new database record that contains the result of the calculation. We're simply running the calculation against preexisting data and returning the result. Uh, oh! This means our API has been breaking the rules of REST since its inception! The alarms in my head sounded!

After some discussion with the other developers, they brought up the point that the calculation request _does_ change data on the server. A user is billed any time that URL is requested.

I understood the logic, but it still didn't seem right to me - a POST should actually create some representation of the URI that the user submits. REST is Representational *State Transfer*, after all, and our POST isn't transferring a new calculation entity onto the server.

After some digging, I found a useful [document](http://www.w3.org/2001/tag/doc/whenToUseGet.html#principles-summary) published by the [W3C](http://www.w3.org). In it they say:

    1.3 Quick Checklist for Choosing HTTP GET or POST
    
    Use GET if:
      The interaction is more like a question (i.e., it is a safe operation such as a query, read operation, or lookup).
    Use POST if:
      The interaction is more like an order, or
      The interaction changes the state of the resource in a way that the user would perceive (e.g., a subscription to a service), or
      The user be held accountable for the results of the interaction.
    
    However, before the final decision to use HTTP GET or POST, please also consider considerations for sensitive data and practical considerations.

Aha! The user _is_ held accountable for the results of the interaction - they're billed for usage! In addition, the user's request will include a key parameter, which is secret, and should not be linkable.

So, if you ever wonder why we settled on a POST vs a GET for running impact calculations on CM1, you now have the whole story.

<!-- more end -->
