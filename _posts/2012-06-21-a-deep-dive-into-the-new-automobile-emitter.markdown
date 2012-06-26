---
title: A Deep Dive Into the New Automobile Emitter
author: derek
layout: post
categories: technology
---

We've made some exciting changes to our automobile emitter. Let's take a look!

<!-- more start -->

## All the fuels

We now support automobile variants like flex fuel and diesel vehicles. If you want to specify, for instance, a flex fuel Ford F-150, you can specify "FFV" as part of the model name, as in this query:

[http://impact.brighterplanet.com/automobiles?make=Ford&modelF150 FFV&year=2012](http://impact.brighterplanet.com/automobiles?make=Ford&model=F150%20FFV&year=2012)

Alternatively, you can specify an [automobile_fuel](http://data.brighterplanet.com/automobile_fuels) and the correct model will be used by CM1:

[http://impact.brighterplanet.com/automobiles?make=Ford&modelF150&year=2012&automobile_fuel=ethanol](http://impact.brighterplanet.com/automobiles?make=Ford&model=F150&year=2012&automobile_fuel=ethanol)

Alternative fuels like electricity, compressed natural gas (CNG) and hydrogen are also supported. One of the most difficult tasks facing anyone trying to calculate automobile emissions is to convert from the EPA's miles per gallon rating to alternative fuel consumption, then convert that fuel value to emissions. We do this all for you, all you need to tell us is distance travelled.

For electric cars, if you specify a country, we will use that country's average emissions from electricity generation. Otherwise, a global average is used.

## Activity Years

We now keep track of "activity years" which determine a range of years that an automobile is used. What this means is that when you say "I drove a Volkswagen Rabbit in 2010," we can get the average emissions for a typical Rabbit that would have been in use in 2010.

## Using distance-based emission factors

Previously, we had used per-unit-fuel emission factors like "0.23 kilograms of CO2 per liter of gasoline." Now we follow EPA's GHG inventory methodology which calculates the amount of CO2 per unit of distance. This better takes an automobile's engine characteristics and air conditioning use into account. 


As always, we are available for support in using CM1. If you're on IRC, you can join us in the #brighterplanet room. You can also email us at <info@brighterplanet.com> or tweet us [@brighterplanet](http://twitter.com/brighterplanet).

<!-- more end -->
