---
title: "Tronprint: Measure the footprint of your cloud application"
author: Derek
layout: post
categories: science, technology
---

One of the major factors contributing to an organization's sustainability, especially for web application companies, is the carbon footprint associated with IT operations. Gartner Research has estimated that the IT sector accounts for [2% of global greenhouse gas emissions](http://www.gartner.com/it/page.jsp?id=503867) and that, "despite the overall environmental value of IT, Gartner believes this is unsustainable."

One of the ways many organizations cut costs and emissions is by outsourcing and virtualizing their IT operations. For instance, many web startups host their applications with services like [Heroku](http://heroku.com) and [Engine Yard](http://engineyard.com). Outsourcing and virtualization helps, but the main disadvantage is that it's difficult to monitor the power usage (and footprint) of your application.

![Tronprint logo](/images/tronprint.png){: style="float:left; margin: 0 10px 0 0;" } This is where [Tronprint](http://brighterplanet.github.com/tronprint) comes in. Tronprint keeps a running total of your application's resource usage as it runs. This resource usage [translates into the total amount of electricity](http://bnrg.eecs.berkeley.edu/~randy/Courses/CS294.F07/20.3.pdf) used by your application. You can even tell Tronprint where your application is hosted, and it will take the server's local electricity source into account when coming up with an emission estimate. For instance, a server powered by a coal power plant is dirtier than one powered by natural gas.

Tronprint allows you to take action in three ways:

* Simply knowing your footprint helps you report reliable sustainability metrics.
* You can use Tronprint to help you choose a hosting location that uses cleaner energy sources.
* By improving the computational efficiency of your application, you reduce emissions---and have metrics to prove it.

If you host your application on Heroku, you can add Tronprint as an "Add-On." The Heroku Add-On is currently in private beta, but will be moving to public beta in the near future.

You can also install the [Tronprint gem](http://rubygems.org/gems/tronprint) today in any Ruby or Rails application. There are detailed instructions at [rdoc.info](http://rubydoc.info/github/brighterplanet/tronprint/master/frames).
