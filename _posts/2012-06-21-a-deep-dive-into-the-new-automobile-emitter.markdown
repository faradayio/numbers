---
title: A Deep Dive Into the New Automobile Emitter
author: derek
layout: post
categories: technology
---

We've made some exciting changes to our automobile emitter. Let's take a look!

<!-- more start -->

## All the fuels

We now support automobile variants like flex fuel and diesel vehicles. If you want to specify, for instance, a flex fuel Ford F-150, you can send this query:

[http://impact.brighterplanet.com/automobiles?make_model_year=Ford F150 FFV 2012](http://impact.brighterplanet.com/automobiles?make_model_year=Ford%20F150%20FFV%202012)

Alternative fuels like electricity, compressed natural gas (CNG) and hydrogen are also supported. One of the most difficult tasks facing anyone trying to calculate automobile emissions is to convert from the EPA's miles per gallon rating to alternative fuel consumption, then convert that fuel value to emissions. We do this all for you, all you need to tell us is distance travelled.

For electric cars, if you specify a country, we will use that country's average emissions from electricity generation. Otherwise, a global average is used.

## Activity Years

We now keep track of "activity years" which determine a range of years that an automobile is used. What this means is that when you say "I drove a Volkswagen Rabbit in 2010," we can get the average emissions for a typical Rabbit that would have been in use in 2010.

## Using distance-based emission factors

Previously, we had used per-unit-fuel emission factors like "0.23 kilograms of CO2 per liter of gasoline." Now we follow EPA's GHG inventory methodology which calculates the amount of CO2 per unit of distance. This better takes an automobile's engine characteristics and air conditioning use into account. 

<!-- more end -->
