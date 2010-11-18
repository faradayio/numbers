---
title: Our latest tool, rapid lifecycle carbon assessment
author: Matt
layout: post
categories: [company, science, technology, homepage]
---

Calculating the exact lifecycle carbon footprint of everyday goods and services is a laborious and often prohibitively expensive process. A few months ago, we set to work building a tool to help organizations get a jump start on estimating the emissions associated with the things they buy. Our goal was a flexible emissions model that could efficiently process existing data streams to calculate carbon estimates as far back through the value chain as possible for a wide spectrum of goods and services.

The result is our new [purchase carbon model](http://brighterplanet.com/payments), released today (see the [press release](http://attachments.brighterplanet.com/press_items/local_copies/74/original/lifecycle_purchase_carbon_tool.pdf?1290031490)). It uses an advanced environmental economic input-output model to calculate a full cradle-to-consumer lifecycle carbon footprint. It works for any product or service. And it can be used automatically in a system that, for example, processes financial transaction data already present in your electronic banking records and procurement logs, giving a quick impression of the hotspots in your purchasing patterns.

To see a demo of the tool in action, check out [Fedprint](http://fedprint.org/), a quick mashup that brings the purchase carbon model to bear on America's largest consumer the, US federal government. Updated hourly, it spotlights the carbon footprint of the most recently awarded contracts in the Federal Purchase Data System.

For developers, the purchase model is live for experimentation and production use on Carbon Middleware. A few developer links: [vehicle purchase (methodology)](http://carbon.brighterplanet.com/purchases?industry=336111&cost=15000), [office supplies (in JSON)](http://carbon.brighterplanet.com/purchases.json?industry=453210&cost=212.98), [carbon model source code](https://github.com/brighterplanet/purchase), [API documentation](http://carbon.brighterplanet.com/purchases/options)
