---
title: "New in CM1: carbon equivalents"
author: andy
layout: post
categories: technology
---

Something we have learned over our 5+ years at Brighter Planet is that, in certain cases, carbon impact can be described most powerfully when it is given in "real life" units. That is, instead of saying a flight has a footprint of 1,045.77 kg CO2e, you say it's like <em>adding 69 cars to the road for a day</em>.

We released a new feature to CM1 a couple of weeks ago that provides dozens of "equivalents" like this with every JSON and XML response we deliver ([example](http://carbon.brighterplanet.com/flights.json)). Reactions so far have been positive, so we're now marking the feature as <em>public beta</em>.

The conversions are part of our new open-source [co2_equivalents](http://github.com/dkastner/co2_equivalents) library---check out the source for details, including complete citations.
