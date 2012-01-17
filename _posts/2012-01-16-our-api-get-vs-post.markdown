---
title: Why the Brighter Planet API uses POST
author: derek
layout: post
categories: technology
---

Have we really created a [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer#RESTful_web_services) web service? If so, why are we [specifying](http://impact.brighterplanet.com/documentation) that users send POST requests to get calculations? I asked this question to the rest of my team and a lively debate ensued among us.

<!-- more start -->

Under the REST convention we use *GET* requests to retrieve data that represents some entity pointed to by a URI. We use *POST* to create a new entity on the server.

When a [CM1](http://impact.brighterplanet.com) user POSTs a calculation request to our service, e.g. POSTing "airline=Delta" to `http://brighterplanet.com/flights.json`, a flight calculation isn't actually stored on our server. Instead, a calculation is run against the data that exists in our database. Why then do we use the POST verb if no resource is actually created?

To answer this question, W3C has a handy [guide](http://www.w3.org/2001/tag/doc/whenToUseGet.html#principles-summary) for determining which verbs are appropriate in different situations:

    1.3 Quick Checklist for Choosing HTTP GET or POST
    
    Use GET if:
      * The interaction is more like a question (i.e., it
        is a safe operation such as a query, read operation,
        or lookup).
    Use POST if:
      * The interaction is more like an order, or
      * The interaction changes the state of the
        resource in a way that the user would perceive
        (e.g., a subscription to a service), or
      * The user be held accountable for the results
        of the interaction.
    
    However, before the final decision to use HTTP GET
    or POST, please also consider considerations for
    sensitive data and practical considerations.

In our case, we have two reasons to use GET:
1. The calculation request results in the user being billed for usage -- "the user is held accountable" for the results.
1. The request contains sensitive information -- the user's API key -- which should not be included in a link to a calcuation. That is, a GET URL should double as a hyperlink reference, but we don't want the API key to be revealed (as in `http://impact.brighterplanet.com/flights.json?key=ABC123`.) Every calculation result includes a GET-able methodology link that doesn't include the API key, so you can safely share the link once the calculation is made.

<!-- more end -->
