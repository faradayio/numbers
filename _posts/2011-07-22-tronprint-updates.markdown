---
title: Tronprint Updates
author: Derek
layout: post
categories: technology
---

This week, some of our servers that were running [Tronprint](http://brighterplanet.github.com/tronprint) started having DNS problems. Tronprint was unable to connect to our MongoHQ database and our sites crashed. We've [updated](https://github.com/brighterplanet/tronprint/compare/da5c208c8799cea84fb0...5d3e57b801add7dc8a45) the Tronprint gem to handle connection issues to any database. In the case of a lost connection or a problem saving statistics, Tronprint will simply keep running and wait for the connection to become available again. This means that data could be lost if a connection is never recovered and the application process quits. However, the connection failure will not affect the operation of your site.

We've also created a [Twitter account](http://twitter.com/tronprint) to keep you updated on new versions and features.
