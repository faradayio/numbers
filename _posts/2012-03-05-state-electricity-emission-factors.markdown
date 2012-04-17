---
title: State electricity emission factors from eGRID
author: Ian
layout: post
categories: science
---

Last week I was trying to calculate the greenhouse gas emissions for each building in the EIA Commercial Building Energy Consumption Survey (CBECS) [microdata](http://data.brighterplanet.com/commercial_building_energy_consumption_survey_responses). Fuel oil and natural gas emissions were easy enough, but electricity emissions posed a problem.

The standard way to calculate electricity emissions in the US is to use EPA [eGRID](http://www.epa.gov/cleanenergy/energy-resources/egrid/index.html) emission factors. To do this I needed to know the [eGRID subregion](http://data.brighterplanet.com/egrid_subregions) each building was in. Usually I'd use data from the EPA [power profiler tool](http://www.epa.gov/cleanenergy/energy-and-you/how-clean.html) to look up the eGRID subregion for each building's [zip code](http://data.brighterplanet.com/zip_codes). But to ensure anonymity CBECS doesn't report a building's zip code or even state, just its [census division](http://data.brighterplanet.com/census_divisions).

<!-- more start -->

My solution was to add population data to most zip codes using [ZCTA data](http://www.census.gov/geo/ZCTA/zcta.html) from the 2010 Census. I then calculated the average electricity emission factor across all zip codes in a census division, weighted by population.

Weighting by population amounts to assuming that the probability of the building being in a particular zip code is proportional to the zip code's population. For this particular application it'd be better to weight by the number of commercial buildings in each zip code, but population should be a reasonable indicator of this.

While I was at it I calculated population-weighted average electricity emission factors for each state and added this data to our [states table](http://data.brighterplanet.com/states). These emission factors are a good alternative if you know the state but not the exact eGRID subregion for electricity use. Ideally I'd weight the zip codes by total electricity consumption, but that data simply isn't available.

<!-- more end -->
