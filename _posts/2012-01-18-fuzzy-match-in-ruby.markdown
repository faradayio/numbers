---
title: Fuzzy match in Ruby
author: Seamus
layout: post
categories: technology techresearch
---

[fuzzy_match](https://github.com/seamusabshere/fuzzy_match) can help link (cross-reference) records across data sources&mdash;for example, match up aircraft records from the [Bureau of Transportation Statistics](http://www.bts.gov) and the [Federal Aviation Administration](http://www.faa.gov/):

<p>
  <a href="http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE" title="BTS aircraft data source">
    <img src="/images/2012-01-18-fuzzy-match-in-ruby/bts_aircraft.png" alt="screenshot of the BTS aircraft data source" />
  </a>
  <a href="http://www.faa.gov/air_traffic/publications/atpubs/CNT/5-2-B.htm" title="FAA aircraft data source">
    <img src="/images/2012-01-18-fuzzy-match-in-ruby/faa_aircraft.png" alt="screenshot of the FAA aircraft data source" />
  </a>
</p>

<!-- more start -->

### Start the easy way ####

Let's look at only the Boeing 737 records for now...

{% highlight ruby %}
bts_records = [
  'Boeing 737-800', 'Boeing 737-5/600lr', 'Boeing 737-500',
  'Boeing 737-400', 'Boeing 737-300lr', 'Boeing 737-300',
  'Boeing 737-100/200', 'Boeing 737-200c'
]
faa_records = [
  '737-100', '737-200, Surveiller (CT-43, VC-96)',
  '737-300', '737-400', '737-500', '737-600',
  '737-700, BBJ, C-40', '737-800, BBJ2', '737-900',
  '737 Stage 3 (US ONLY)',
]
require 'fuzzy_match'
puts [ 'BTS'.ljust(24), 'FAA' ].join    # print a nice table header
matcher = FuzzyMatch.new(faa_records)   # set up a matcher object
bts_records.each do |bts|
  faa = matcher.find(bts)               # given BTS record as input, find a matching FAA record
  puts [ bts.ljust(24), faa ].join      # print a row showing the match
end
{% endhighlight %}

which produces

<pre>$ ruby example.rb
BTS                     FAA
Boeing 737-800          737-800, BBJ2
Boeing 737-5/600lr      737-600
Boeing 737-500          737-500
Boeing 737-400          737-400
Boeing 737-300lr        737-300
Boeing 737-300          737-300
Boeing 737-100/200      737-100
Boeing 737-200c         737-100</pre>

### Then add rules ####

Fuzzy matching may catch 90% by itself, but you will have to define rules to get to 95% or 99% accuracy.

For example, oops! "Boeing 737-200c" is matching "737-100". Let's tell <code>FuzzyMatch</code> about the "7X7-XXX" <em>identity</em>...

{% highlight ruby %}
identities = [ /(7\d7)-?(\d\d\d)/ ] # for records containing 7X7, make sure the last 3 digits match
matcher = FuzzyMatch.new(faa_records, :identities => identities )
{% endhighlight %}

which produces

<pre>Boeing 737-200c         737-200, Surveiller (CT-43, VC-96)</pre>

You can make the following kinds of rules:

<dl>
  <dt><tt>:blockings</tt></dt>
  <dd>group records into blocks (for example, <code>/boeing/i</code>)</dd>
  <dt><tt>:identities</tt></dt>
  <dd>patterns that must match on both "sides" (<code>/(F)\-?(\d50)/</code> ensures that "Ford F-150" and "Ford F-250" never match)</dd>
  <dt><tt>:tighteners</tt></dt>
  <dd>reduce records to the essentials (<code>/(boeing).*(7\d\d)/i</code> removes "INCORPORATED" from "BOEING INCORPORATED 737")</dd>
  <dt><tt>:stop words</tt></dt>
  <dd>ignore common words ([for example, THE or CANNOT](http://www.ranks.nl/resources/stopwords.html))</dd>
</dl>

Also check out the options:

<dl>
  <dt><tt>:must_match_blocking</tt></dt>
  <dd>don't return a match unless the needle fits into one of the blockings you specified</dd>
  <dt><tt>:must_match_at_least_one_word</tt></dt>
  <dd>don't return a match unless the needle shares at least one word with the match</dd>
  <dt><tt>:first_blocking_decides</tt></dt>
  <dd>force records into the first blocking they match, rather than choosing a blocking that will give them a higher score</dd>
</dl>

Check out the [fuzzy_match documentation](https://github.com/seamusabshere/fuzzy_match) for more information.

<!-- more end -->
