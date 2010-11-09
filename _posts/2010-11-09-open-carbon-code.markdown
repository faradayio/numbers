---
title: Open carbon code
author: Andy
layout: post
categories: technology
---

There's been a flurry of commentary about opening up climate model code over the past month, mostly centered around an [article in _Nature_](http://www.nature.com/news/2010/101013/full/467775a.html) back in October. The discussion really broke out into the tech blogs when John Graham-Cumming [opined](http://blog.jgc.org/2010/11/real-reason-climate-scientists-dont.html) on the reason for all the secrecy. I'm not sure I agree with his final diagnosis&mdash;that it's just about scientists trying to not look foolish&mdash;but his call-to-action is right on:

> If everyone released code then there would be (a) an improvement in code
> quality and (b) an 'all boats rise' situation as others could build on
> reliable code

Here's what we're doing at Brighter Planet:

* We release all of our [carbon models](http://carbon.brighterplanet.com/science) as open-source code under the AGPL.

* We provide custom-generated methodology documentation [like this](http://carbon.brighterplanet.com/flights?origin_airport%5Biata_code%5D=JAC&destination_airport%5Biata_code%5D=SFO) for every one of our calculations.

* We're now using [Rocco](http://rtomayko.github.com/rocco/) to do literate-style documentation of our methodologies ([example](http://brighterplanet.github.com/flight/carbon_model.html)), with specific focus on compliance with standard carbon accounting protocols.

The sad truth is that if you enter the same input data into each of the hundreds of carbon calculation software packages available now, you're going to get a different answer each time. To be fair, all science is uncertain, so this is somewhat to be expected. But with transparency---especially documentation and open-source code---at least we'll know why.
