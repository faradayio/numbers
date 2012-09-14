---
title: The Green Button that could have been
author: Andy
layout: post
categories: technology
---

What's the first step in discovering efficiency opportunities? **Data, data, data**. That's what we always say here at [Brighter Planet](http://brighterplanet.com), where we're trying to [compute our way](http://impact.brighterplanet.com) to a more hopeful environmental future.

So I'm sure it won't surprise you when I say that the key to the energy challenge also starts with data: **how much** we're using and **when** and **where** we're using it. Which makes it all the more poignant to write this critique of the much-lauded [Green Button](http://greenbuttondata.org/) program, which ostensibly is *all about* opening up energy data.

The truth is that Green Button, as a government advocacy program, has not succeeded in unleashing the gold rush of energy efficiency magic we know is locked up in the heads of entrepreneurs. Developers aren't building apps, consumers aren't using them, and utilities aren't playing ball. **Frankly it's hard to blame them.** Luckily there's a better way to do Green Button, using modern technology to truly empower energy consumers in a lasting, meaningful way. But first . . .

<!-- more start -->

### Back to the beginning

Green Button started as a gleam in **U.S. CTO Aneesh Chopra**'s eye. At the [GridWeek2011](http://www.gridweek.com/2011/) Smart Grid event, Aneesh challenged the energy industry to provide consumers with a "green button" you can click to download detailed energy use data. Here's the bit from his keynote:

<object class="wide" width="651" height="366"><param name="movie" value="http://www.youtube.com/v/EZIkzRXJl38?version=3&amp;hl=en_US&amp;rel=0&amp;start=1353"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/EZIkzRXJl38?version=3&amp;hl=en_US&amp;rel=0&amp;start=1353" type="application/x-shockwave-flash" width="651" height="366" allowscriptaccess="always" allowfullscreen="true"></embed></object>

His oratory is certainly inspiring, and, had I been there, I would have been **roused to standing applause**. But now I can't help but wonder if the seasoned (grizzled?) energy infrastructure veterans in the crowd immediately saw the flaws in the Green Button challenge.

I've met Aneesh twice (at [Strata](http://strataconf.com) and then later at [CleanWebHackathon](http://www.cleanweb.co/)) and both times said to myself, *here is a sharp guy.* In conversation he is refreshingly blunt and he clearly does not put up with nonsense.

So although Green Button is now deserving of this critique, I do not believe Aneesh intended for it to be the empty tease it is today. As he said himself in the keynote, **"Nothing'll be perfect on day one,"** and so, in that spirit, I will explain where I think this simple promising concept went **so completely wrong**.

### Buttons galore

If you rewind the video a bit, you'll see that before Aneesh issues his challenge, he describes a program called [Blue Button](http://www.va.gov/bluebutton/), launched at the Veterans Administration, that allows patients to download their medical history with the proverbial click of a blue button.

Using the VA program as inspiration was Green Button's **original sin**. If you look at Blue Button [promotional materials](http://bluebuttondata.org/faq.php), you'll find phrases like "human readable" and "easy-to-read." Sure, we can program computers to interpret Blue Button files, but their primary purpose is to *inform humans*. **Don't believe me?** Take a look at a [sample file](http://www.va.gov/BLUEBUTTON/docs/VA_My_HealtheVet_Blue_Button_Sample_Version_12_All_Data.txt):

    Allergy Name: Pollen
    Date:         18 Mar 2010
    Severity:     Mild    
    Diagnosed:    Yes
    
    Reaction: Watery eyes, itchy nose 
    
    Comments: Took an over the counter antihistamine

Eyes watering yet?

### A smart move

One thing Green Button got right was its data exchange format. Even though the data we're talking about sounds simple (just a bunch of meter readings with timestamps) there has to be an agreed-upon way to serialize this data, and it turns out there's an **existing standard**---NAESB's [ESPI](http://www.naesb.org/ESPI_Standards.asp)---for doing just that.

Green Button's adoption of ESPI was an **excellent step in the right direction**. The [data files](http://greenbuttondata.org/data/15MinLP_15Days.xml) are really *quite simple* to parse and use with [existing](https://github.com/energyos/OpenESPI) [tools](http://nokogiri.org/). It would have been all too easy to follow Blue Button too closely and specify a newline-delimited or otherwise "human readable" file format. Although **who knows** what your average human would be able to do with this:

> 2012-03-01 00:00 to 2012-03-01 00:15  0.302 kWh $0.01  
> 2012-03-01 00:15 to 2012-03-01 00:30  0.302 kWh $0.01  
> 2012-03-01 00:30 to 2012-03-01 00:45  0.302 kWh $0.01  
> 2012-03-01 00:45 to 2012-03-01 01:00  0.302 kWh $0.01  
> 2012-03-01 01:00 to 2012-03-01 01:15  0.302 kWh $0.01  
> 2012-03-01 01:15 to 2012-03-01 01:30  0.302 kWh $0.01  
> 2012-03-01 01:30 to 2012-03-01 01:45  0.302 kWh $0.01  
> 2012-03-01 01:45 to 2012-03-01 02:00  0.302 kWh $0.01  
> 2012-03-01 02:00 to 2012-03-01 02:15  0.302 kWh $0.01  
> 2012-03-01 02:15 to 2012-03-01 02:30  0.302 kWh $0.01  
> 2012-03-01 02:30 to 2012-03-01 02:45  0.302 kWh $0.01

### Manual labor

With a human endpoint in mind, Blue Button's "download this file to your computer and use it how you'd like" interaction model makes *perfect sense*. Patients will likely email the file to their doctor or print it out and bring it to an appointment.

But with energy data, where real value comes from continuous computer analysis, this model is **truly inappropriate**. Here's what I, as an energy consumer, must do to leverage the Green Button program:

1. Discover an interesting energy app
1. Open a new tab
1. Find my utility's website
1. Log in
1. Find the green button (if it exists!) and click it
1. Choose a place on my computer to save the file
1. Go back to the first tab
1. Click the app's "upload" link
1. Find the location I saved by data file on my computer

I'll admit this list is a bit verbose, but you get my point: **it's a bore**. The energy app in step 1 is going to have be *incredibly interesting* to drive a user through this interaction. And here's the **really awful part**: you have to go through all of these steps *every time* you want your energy app to have access to new data.

Imagine if in order to use [Mint.com](http://mint.com) you had to visit every one of your online banking accounts every morning, download exports of your transactions, and upload them to your Mint.com profile. **That's what we're dealing with** when it comes to today's Green Button.

To put it simply, this is just an **unworkable model** for developers for anything beyond experimentation. It's ridiculous to expect your users to go through this process (repeatedly) to draw value from your application, which means a **user base of approximately zero**, which means a revenue stream of roughly the same amount.

I'll be honest that my first reaction to hearing about the [Apps for Energy](http://appsforenergy.challenge.gov/) contest was to be a **bit insulted**. Why should developers spend their valuable time building software on a platform that by its very nature precludes meaningful, lasting user relationships? Well, at least there were **cash prizes**.

### A way forward

What we need is a system that allows us to tell our utility that it's OK for an energy app we like to have ongoing access to our electricity usage data. This is how we're able to allow apps like Tweetdeck to look at our Twitter feeds without downloading all of our tweets from Twitter and uploading them to Tweetdeck. It's how we can add apps to our Facebook accounts that do cool things with our social data.

This paradigm---applications talking to other applications, about us, with our permission---is the **enduring reward** of Web 2.0, and it's exactly what we need in energy land.

If we can achieve this, it *won't look much like today's Green Button at all*. We'd probably stick with ESPI for data exchange, but there wouldn't even be a "green button" involved. (Recall that to add an app to a given platform, you start with the *app*, which send you over to a "yes/no" authorization page on the platform.)

There's already a **time-tested, secure, best-practice** way of doing this ([OAuth](http://en.wikipedia.org/wiki/OAuth)) that will allow energy app developers to accept data in a universal format with a common authorization process, regardless of the user's utility. All the developer will need is a database listing the OAuth endpoints for each utility in the country.

### Making the case

And, of course, **that's the rub**. Adoption by utilities of the Green Button program has been [underwhelming](http://greenbuttondata.org/greenadopt.html) to say the least: only *five* have actually posted the clickable green button to their sites. I don't think we can ask each utility to voluntarily expose a usage data endpoint via OAuth authentication and expect a more enthusiastic response.

I know that Aneesh liked to fly a bit **below the radar** (alas he's not CTO anymore), championing solutions that don't require budget outlays, laws, executive orders, or political dogfights. But this is a place where we *really need* government direction: **all U.S. electric utilities should be required to offer ESPI data at an OAuth endpoint by Jan. 1, 2014.**

### Meanwhile

But of course we developers **don't like to sit still**. Theoretically we could build a proxy system that automatically "logs in" to utility accounts, downloads Green Button data, and feeds this data to authorized applications on the user's behalf.

This is what we did with [Sparkwire](http://sparkwire.io), and **boy was it a bear**. We were only able, in fact, to produce a driver for *one* utility---PG&E---and for that we had to whip out the **nuclear weapon** of application integration: screen scraping. Behold:

<script src="https://gist.github.com/3131346.js?file=pge.rb"> </script>

*What a mess.* And we'd have to do this for each and every utility around the country that we want to support. But in the end, I suppose, that's better than expecting every one of our users to go through the **download/upload song-and-dance** every time they wanted some new insight.

### In conclusion

If we truly want to empower energy consumers, we must replace Green Button's "download/upload" torture with a modern, OAuth-powered **"app and platform"** model. To do this, we either have to prevail upon utilities nationwide to *get with the program*, or we use a proxy like Sparkwire and write drivers for the [3,000-odd](http://data.brighterplanet.com/electric_utilities) electric utilities around the country.

Either way, it's daunting. But it's gotta happen. **Who's in?**

### P.S.

How incredible is it that they're even *thinking* about something as obscure as energy use data exchange formats in the top advisory levels of the White House? Heady times!
<!-- more end -->
