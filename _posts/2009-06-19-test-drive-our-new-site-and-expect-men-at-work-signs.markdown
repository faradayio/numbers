--- 
wordpress_id: 1544
layout: post
author: bessie
title: "Test-drive our new site! (And expect \xE2\x80\x9CMen at Work\xE2\x80\x9D signs.)"
categories: technology
wordpress_url: http://blog.brighterplanet.com/?p=1544
---
At 2pm on Wednesday, June 17, <a href="http://beta.brighterplanet.com">we opened the doors of Brighter Planet v2.0 to beta testers</a>.

We've put our all into this. Risked life and limb, I tell you -- courted eyestrain, sleep deprivation, carpal tunnel, general crabbiness. Picture, then, the  huge gust of giddy elation that blew through the team when the site went live and didn't break the entire interwebs! W00t!! Jigs were danced, rafters swung from ... I believe the web developers actually emptied the Gatorade jug onto the head of our CTO, <a href="http://beta.brighterplanet.com/users/adam">Adam</a>.

All this went on for about 10 minutes, and then deep breaths were taken and we all got back to work. We turned on the lights with our to-do list still measured in tonnage -- and intentionally so. The reason? We know that you, our eagle-eyed and creative beta testers, will think of things we'd never dream up in a million years -- you'll identify software bugs, solve design problems, and suggest new features that we're not able to see from our swimming-in-the-soup perspective. We'll wind up with a smarter, more usable, and ultimately more useful set of tools with you all involved in decisions about where to go from here.

Great feedback has been rolling in from wonderful beta testers like <a href="http://getsatisfaction.com/people/sarah_franco">Sarah</a> and <a href="http://getsatisfaction.com/people/karen_332923">Karen</a>. (We can't thank you guys enough, and are all ears for whatever additional observations you may come up with.) We hope all ye who read this will <a href="http://beta.brighterplanet.com">give the application a whirl</a> and <a href="http://getsatisfaction.com/brighterplanet">get involved in the dialogue</a>!

Meanwhile, there are crews at work everywhere on the beta site -- it's the web-application equivalent of a skyscraper construction site in there. There are functions that aren't working quite right, that aren't yet explained well (blame me -- I'm the guy who does most of the 'splainin' about how things work), and that simply aren't ripe. Here's a round-up of high-priority problems we'll solve asap and sorely needed features we're committed to releasing in the near future:
<h3>What's Broke:</h3>
<strong>STUFF WE'RE FIXING IN THE "YOUR FOOTPRINT" CALCULATOR:</strong> Our new calculator is the heart of the application, and we're proud of it -- when it's finished, we're pretty sure it'll be the most user-friendly, empowering personal footprint calculator out there. We mean to help you do a <em>complete </em>accounting of your lifestyle's climate impact, just as the best money-management and weight-management tools help you take inventory in those areas of your life. After you've made a good dent in filling it out, you'll have -- <em>cha-ching! -- </em>a complete, cruising-altitude view of all you do that has an impact, showing you where there's real room for improvement, and allowing you to register your accomplishments and track your progress toward a lighter footstep.

So that's our target for the calculator. At present there are both major and minor things needing fixin':
<ul>
	<li>Top priority is resolving our suspicion that the calculator is sometimes outputting inaccurate overall footprints -- user feedback and our own observations suggest that some calculations are skewing too high. The calculator's underlying fundamentals are rock-solid but some data-caching problems we've been experiencing could be throwing off the web application's tabulations. Our credibility depends on providing accurate footprint estimates, and our science and tech teams are working hard on this.</li>
	<li>Also high on the list: bad sums -- breakdowns by percentage may not add up to 100; the value displayed for your overall footprint may not match what you get doing your own math adding up the values displayed for your four footprint "components" (Transportation, Shelter, Consumables, Shared Services; etc. Again, data caching issues may be causing the hinky tabulations.</li>
	<li>Another one: say you tell the calculator you drive a Saturn. Next question posed will be "Select your car's model" -- but the list of models you're asked to choose from are <em>Toyotas</em>, not Saturns. Suspected cause? You guessed it -- data caching issues.</li>
	<li>Unwieldy, unalphabetized pulldown lists: "select the airport your flight departed from," for example. We're implementing something that will make these much easier to use.</li>
	<li>Opting out of a particular footprint element, e.g. "I don't [own a car; own a dishwasher; take ferry trips, etc]": It's been reported that crossing off one of these isn't always causing your footprint to be revised downward -- it should, and we're investigating. (Also, please excuse the sometimes truly inelegant phrasing of these -- our favorite is "<em>I never occupy residences.</em>"</li>
</ul>
<strong>OTHER STUFF WE'RE FIXIN': </strong>

A grab-bag:
<ul>
	<li>browser compatibility: We're trying to resolve some minor weirdness occuring when viewing the site in Safari and Internet Explorer 8. (<em>Note: for now at least, we're <strong>not</strong> supporting IE6. We'll revisit if site traffic suggests that we should.)</em></li>
	<li>Design ickyness: Throughout the application, some of the forms look fugly, as do some pages in the Carbon Offsets section, and (according to one user) the homepage itself (yipe!). They work (or should, anyway), but aren't yet pretty. Some just need to be styled properly and we're confident you'll like their looks; others -- hey, we'll consider all suggestions; keep 'em coming.</li>
	<li>In Conservation Tips, clicking "I Did This" is still sometimes producing errors. Most likely, this is happening simply because someone's doing some work that throws off performance until they're finished, but we're investigating.</li>
</ul>
<h3><strong>What's Coming:</strong></h3>
Once these goodies are in place, we're confident your experience of the site will be slick and fun indeed:
<ul>
	<li><strong>More depth and granularity in the calculator, especially in the Consumables area. </strong>This is a critical one: The goods and services Americans consume are the source of a huge chunk of our individual carbon footprints -- and most carbon calculators just sidestep this part of the picture. We want our accounting to consider ALL the lifecycle climate impacts of a person's lifestyle. My understanding is that while there's solid data about one's overall consumables footprint, we've got some work to do yet in sourcing and baking into the calculator data about consumables that allows for the same sort of thorough inventory of habits and choices that you'll experience with, for example, the Transportation-footprint calculator. That's where we're headed, for sure, and you'll see more detail here going forward.</li>
	<li><strong>Analytics / visualizations. </strong>Also critical -- we want to provide graphs and other visualizations that give you an at-a-glance handle on what's creating your footprint, how your footprint ranks compared to national (and global) averages, what sort of progress you're making, and where the low-hanging fruit lies. Just for starters. <strong>
</strong></li>
	<li><strong>Transparent methodology. </strong>Every page of the calculator will allow you to peak under the hood and see what our data sources are and how the calculations are being done.</li>
	<li><strong>More robust privacy options. </strong>You'll be able to decide, in a granular way, what information about yourself and your footprint you want to share with everyone, with just your friends, or with no one.</li>
</ul>
There are many more, but that's the short list. Want to leave lots of breathing room for your own ideas to form -- if you're not doing so already, please <a href="http://beta.brighterplanet.com"><strong>sign up as a beta tester</strong></a> and <a href="http://getsatisfaction.com/brighterplanet"><strong>start filing feedback</strong></a> if you like!
