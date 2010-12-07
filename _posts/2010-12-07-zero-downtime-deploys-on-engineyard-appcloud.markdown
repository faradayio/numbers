---
title: Zero downtime deploys on the EngineYard AppCloud
author: Seamus
layout: post
categories: [technology]
---

One of the ways we maximize our uptime is by tag-teaming two full production clusters:

<div class="wide">
  <img src="/images/2010-12-07-zero-downtime-deploys-on-engineyard-appcloud/red-and-blue-environments.png" alt="screenshot of EngineYard AppCloud dashboard with two environments, red and blue"/>
</div>

Both "red" and "blue" can support 100% of our traffic, but only one of them is in charge of [carbon.brighterplanet.com](http://carbon.brighterplanet.com) at a time. That way, we can make updates to the other one, test it at full production capacity, and "tag it in" when it's ready (by changing DNS).

This is better for us than using staging environments because we're not holding our breath for that "final" deploy to production. The tag-team approach lets us keep the old production environment running unchanged, ready to tag back in if the deploy process goes wrong.

It's **strong rollback**, in the sense that all the last-known-good instances are still running (at least until we're totally comfortable with the new ones.) It's also **graceful**, in the sense that clients are not presented with a maintenance page or scheduled outage windows.

### Fact: we have to store stuff offsite ###

If non-replicable data lived in the database master on red or blue, then we would have to export and import it every time we tagged in or out. To solve this, we make sure that all such data is stored offsite in [our reference data web service](http://data.brighterplanet.com), [Amazon S3](http://aws.amazon.com/s3), [hosted Mongo](http://mongohq.com), etc.

### Fact: we have to wait for DNS ###

When we switch [carbon.brighterplanet.com](http://carbon.brighterplanet.com) from red to blue, we have to wait for the DNS change to propagate. If we want to roll back, we might have to wait again. As long as the old production environment worked but just had old code, this is usually OK.

### Fact: we pay for more compute hours ###

For a while before and after any deploy, we need both red and blue at full production capacity. That costs compute hours. We think it's worth it to avoid a single point of failure.

### Fact: we rebuild from scratch more often ###

When we're not preparing for a deploy, we may take red or blue down (whichever's not "it") to save money. When we prepare for a deploy, therefore, we need to rebuild the instances from scratch. Since we keep our build scripts up-to-date, this has not been a problem.
