---
title: "20,000,000 calculations . . . spooky"
author: Andy
layout: post
categories: company
---

![Haunted house](/images/haunted_house.png)

Sometime in the darkest hours of Halloween night, our [CM1 platform](http://impact.brighterplanet.com) processed its **20,000,000th calculation**. Hurray!

But wait: after a couple days of intense analysis, we're concluding that the [Residence](http://impact.brighterplanet.com/models/residence) impact being computed was that of a *bona fide* haunted house. We present our argument below.

<!-- more start -->

Here's the raw request characteristics (location removed to protect the <del>innocent</del> residents):

{% highlight ruby %}

{ :acquisition => "2008-09-01",
  :air_conditioner_use => "NOT USED AT ALL",
  :annual_coal_volume_estimate => "0.0",
  :annual_fuel_oil_volume_estimate => "0.0",
  :annual_kerosene_volume_estimate => "0.0",
  :annual_propane_volume_estimate => "0.0",
  :annual_wood_volume_estimate => "0.0",
  :clothes_drier_use => "1",
  :dishwasher_use => "4 TO 6 TIMES A WEEK",
  :floors => "1",
  :floorspace_estimate => "111.484",
  :freezer_count => "0",
  :monthly_electricity_use_estimate => "600.0",
  :occupation => "0.937",
  :ownership => "false",
  :refrigerator_count => "1",
  :residence_class => "APARTMENT BUILDING WITH 2-4 UNITS",
  :residents => "3",
  :retirement => "2009-10-07",
  :timeframe => "2011-01-01/2012-01-01",
  :urbanity => "TOWN" }

{% endhighlight %}

As you see, the evidence is clear. Who, besides restless spirits, never use air conditioning? And the 94% occupancy rate means the "residents" are absent 21 days per year---roughly the number of days with a full or near-full moon. Could these dear tenants be, perhaps, quietly stalking the unaware?

Sure, we can't explain why these three poltergeist lodgers would need a refrigerator or wash so many dishes, but, after all, there's no accounting for taste.

So there we have it, **proof positive**: ghosts are using CM1.

<!-- more end -->
