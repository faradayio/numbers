---
title: A closer look at public data cleanup
author: Matt
layout: post
categories: science
---

Our CM1 [carbon models](http://carbon.brighterplanet.com/models) depend on lots of public energy and emissions data relating to things like buildings and transportation---mostly from government sources like the [EIA](http://www.eia.doe.gov/), [BTS](http://www.bts.gov/), and [EPA](http://www.epa.gov/). Whenever you use or mash up a large dataset you'll likely run into issues like inconsistent file layouts, awkward formats, and human error. So file cleanup is a large part of the process we go through when plugging data into our system and making them available in our free [data clearinghouse](http://data.brighterplanet.com/). Here's a quick look at three of the main things we do; we'll delve into more specifics in subsequent posts:

*	__Error correction.__ Most datasets are pretty good, but with some containing millions of data points, human error is bound to work its way in. We use search algorithms to identify typos and outliers, and then manually correct or delete flawed entries.

    *For example:* The [EPA Fuel Economy Guide](http://www.fueleconomy.gov/) files from 1985 through 2010 contain various typos and inconsistencies. We list corrections to each of these in an errata file that we apply during the import process.

*	__Restructuring.__ Some databases have attribute names that change over time. Others have attributes that contain both numerical data and numerical codes and so require special analysis techniques. In both of these cases we parse the data into a single format that is convenient for calculations.

    *For example:* The EIA's [Commercial Buildings Energy Consumption Survey](http://www.eia.doe.gov/emeu/cbecs/) includes codes like 99999 for nautral gas use when a building never uses natural gas.  The [EPA Fuel Economy Guide](http://www.fueleconomy.gov/) uses four different sets of attribute names from 1985 through 2010. 

*	__Data extraction.__ Some data come from report tables that are only available as a PDF file or in print. We manually extract these data and make them available in formats like CSV, JSON, XML, and SQL that can plug into the modern information ecosystem.

    *For example:* The [APTA Public Transportation Fact Book Appendix A](http://www.apta.com/resources/statistics/pages/transitstats.aspx) is only available in PDF format.

We take all the public data we clean up for our clients' use and post it on [our data site](http://data.brighterplanet.com/) so others can benefit as well. It's available for download in multiple formats. And it's kept up to date using automated import programs that crawl government agency websites and automatically import the latest data updates as soon as they're available.

