---
title: Bringing carbon calculations to TripIt
author: Scott
layout: post
categories: technology, fellowship
---

It’s a privilege to be posting here on Safety in Numbers, and particularly exciting to do so as Brighter Planet’s first [Developer Fellow](http://brighterplanet.github.com/fellowship.html). I was an early Brighter Planet cardholder and have watched the team closely, so it’s great to get a chance to work with them.
 
For a few weeks now, I have been working with Brighter Planet [CM1 API](http://carbon.brighterplanet.com/) to create TripCarbon, an automated tool that calculates carbon output from [TripIt](http://www.tripit.com) itineraries.  If you’re not familiar with Tripit, you can send it your travel confirmation emails and it creates amazing online itineraries with real-time status updates, loyalty program points tracker (for pro users), refund tracking, and more. I’ve been using TripIt for several years, and it’s one of the most powerful web tools I use.
 
Adding carbon data to TripIt will allow the many users of Tripit to easily and automatically see the carbon use of their trips. Why is this useful? Armed with this knowledge, they can offset their trips or make trip-planning decisions which minimize carbon use. A former employer of mine offset all business travel; with this tool, it will be much easier to offset the appropriate amount of carbon with minimal work. Personally, it's great to be working on something that I'll use regularly.
 
Working with the CM1 tool has been a breeze. Since I’ve been using Ruby on Rails, I’ve been able to use the [Carbon gem](https://github.com/brighterplanet/carbon) to easily extend my Rails models. I’ve also used the handy [Conversions gem](https://github.com/seamusabshere/conversions) to handle unit conversions.
 
After setting up my API key and adding the Carbon gem to my Gemfile, calculating emissions for my flight model was as simple as providing data from TripIt’s API:
 
` emit_as :flight do
    provide :origin_airport
    provide :destination_airport
    provide :airline
    provide :segments_per_trip
    provide :trips
    provide :start_date, :as => :date
    provide :aircraft
    provide :distance_in_kilometers, :as => :distance_estimate
    provide :timeframe
  end`
 
The data I get from TripIt isn't always consistent, since it gets pulled from confirmation emails, but CM1 is amazingly flexible with data inputs. For instance, it recognize various code types for airlines and aircrafts. Or if the distance isn't available, it can calculate it automatically from the origin and destination airports. CM1 returns not only the emissions estimate, but also a link to the full methodology, which I can then add to the relevant TripIt note.

I’m still working on my app, but I look forward to sharing it with you soon. Thanks for reading.

Scott Bulua
Developer Fellow