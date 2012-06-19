---
title: How to write a great HTTP API client
author: derek
layout: post
categories: technology
---

When you have an API, it's really important to make it easy to use and perform well. Here are some of the principles and technologies we used to build the [Carbon gem](http://rubygems.org/gems/carbon), our Ruby client for [CM1](http://impact.brighterplanet.com).

<!-- more start -->

## It's gotta be easy

Think of your developers and first-timers. You don't want your developers to waste time with sign-ups and weird object instantiation patterns. A good API is one that takes very little configuration and setup. If I want to run a query, I want to do it with as few lines of code as possible. With our carbon gem you can be up and running with a single line of code:

    result = Carbon.query('Flight', :origin_airport => 'MSN', :destination_airport => 'ORD')

No account setup is needed until you're in production. Once you're ready, you can sign up for an API key and set it:

    Carbon.key = 'MyKeyABC'

Another benefit of a simple API is that it's easier to mock out when testing an application against it.

## You need to have TFM that can be R'd

Good documentation is key. Never assume a new user is familiar with all of the terminology your API uses and explain it well. Note that the simpler your API is, the easier it'll be to write documentation.

Ruby gems can be commented to provide RDoc-formatted documents. Having a dedicated web page for your client or API can be a big help. For instance, our [CM1 site](http://impact.brighterplanet.com/), rather than being a brochure for our service, is a guide to using our API and an introduction to our language-specific API clients.

## Eat your own dog food

By using your API for your own projects, you instantly become a critic of your own work. The great benefit is that because you own the API, you get to change it if you don't like it! This is particularly useful in early stages of API development.

## Use VCR

[VCR](http://github.com/myronmarston/vcr) is a great testing tool that fakes out HTTP requests so that your tests run quickly and are run against real responses. A nice feature of VCR is that you can configure it to refresh response data, say, every month so you can verify that your client still works with your latest API.

## Make it fast

Performance can be a major obstacle to developers adopting your service. It's best to save them the trouble of handling performance issues by providing a solution. This goes hand-in-hand with eating your own dog food. We took our own pattern of parallelizing CM1 requests and baked it into the carbon gem. Simply pass `Carbon.query` an array of calculations to perform, and we'll use the amazing [Celluloid gem](http://rubygems.org/gems/celluloid) to parallelize the requests. Celluloid provides a pool of threaded workers for this task.

## Make it asynchronous

An interesting trend among API providers has been the idea of providing a queued interface. This makes asynchronous processing much easier for developers and also takes some load off of your web servers. We even played around with an SQS-based client at one time with our carbon gem. In the future, we could see a Socket.IO-based, asynchronous API for our JavaScript client.

<!-- more end -->
