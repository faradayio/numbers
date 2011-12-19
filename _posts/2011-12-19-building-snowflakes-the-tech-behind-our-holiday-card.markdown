---
title: "Building snowflakes: the tech behind our holiday card"
author: Andy
layout: post
categories: technology
---

Last week we [posted our 2011 holiday card](http://numbers.brighterplanet.com/2011/12/16/let-it-snow), which has seen quite a bit of traffic since. There's actually some pretty interesting new technology under the hood, so I thought I'd put together this behind-the-scenes blog post for anybody who's interested.

<!-- more start -->

When designing the card, I knew that I wanted to use a kind of **real time** animation to express the diverse flow of calculations that [CM1](http://impact.brighterplanet.com) is performing at any given time. Until recently "real time" on the client side meant *polling*, but the recent introduction of [**WebSockets**](http://dev.w3.org/html5/websockets/) has changed all that.

Ultimately I decided to use [Pusher](http://pusher.com), an incredible service that abstracts away a lot of the messiness of using WebSockets in a ["pubsub"](http://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) architecture. Implementing Pusher on the server side meant adding this single line to the right place in CM1's codebase:

{% highlight ruby %}
::Pusher['queries'].trigger!('announce', billed_query.slice('emitter', 'carbon_value'))
{% endhighlight %}

What this does: every time a calculation is made on CM1, the "queries" channel within the "CM1" app of our Pusher account receives an "announce" notification including two details from the query (the name of the impact model and its footprint).

On the client side, the app sets up every browser to act as a "subscriber" to this channel with these three lines in `index.html`:

{% highlight javascript %}
pusher = new Pusher('4441a27a742385492eb3'); // that's our public Pusher key
queries = pusher.subscribe('queries');
queries.bind('announce', displayQuery)
{% endhighlight %}

Now, every time a query is performed on CM1, Pusher gets a notification, and this kicks off notifications to all of the browsers currently looking at the card, each of which execute the `displayQuery` function with the impact model's name and footprint as parameters.

OK, now we now how the card gets the details to display as snowflakes, but how do we draw the actual snowflakes themselves?

For this we use **HTML5's [Canvas](http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html)** element for dynamic drawing and animation. In truth, most of the messy animation stuff is handled by the excellent **[Three.js](https://github.com/mrdoob/three.js)** library; the appearance and motion of the snow was inspired by a [post from Seb Lee-Delisle](http://sebleedelisle.com/2010/11/javascript-html5-canvas-snow-in-3d/). I just made a few visual modifications and wired it all up to the notifications coming in from Pusher.

So, there you have it. Happy to clarify things or answer questions in the comments. Happy holidays!

<!-- more end -->
