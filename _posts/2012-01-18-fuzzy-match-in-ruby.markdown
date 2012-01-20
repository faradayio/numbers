---
title: Fuzzy match in Ruby
author: Seamus
layout: post
categories: technology techresearch
---

Our [`fuzzy_match`](https://github.com/seamusabshere/fuzzy_match) library for Ruby can help link (cross-reference) records across data sources&mdash;for example, match up aircraft records from the [Bureau of Transportation Statistics](http://www.bts.gov) and the [Federal Aviation Administration](http://www.faa.gov/):

<p>
  <a href="http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE" title="BTS aircraft data source">
    <img src="/images/2012-01-18-fuzzy-match-in-ruby/bts_aircraft.png" alt="screenshot of the BTS aircraft data source" />
  </a>
  <a href="http://www.faa.gov/air_traffic/publications/atpubs/CNT/5-2-B.htm" title="FAA aircraft data source">
    <img src="/images/2012-01-18-fuzzy-match-in-ruby/faa_aircraft.png" alt="screenshot of the FAA aircraft data source" />
  </a>
</p>

<!-- more start -->

### 90% of the way by default ####

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

{% highlight console %}
$ ruby example.rb
BTS                     FAA
Boeing 737-800          737-800, BBJ2
Boeing 737-5/600lr      737-600
Boeing 737-500          737-500
Boeing 737-400          737-400
Boeing 737-300lr        737-300
Boeing 737-300          737-300
Boeing 737-100/200      737-100
Boeing 737-200c         737-100  # <- oops!
{% endhighlight %}

### Add rules to get to 95% ####

Fuzzy matching may catch 90% by itself, but you will have to define rules to get to 95%.

In this case, the error is "Boeing 737-200c" matching "737-100". Let's use an "identity" rule for "7X7-XXX"...

{% highlight ruby %}
identities = [
  %r{(7\d7)-?(\d\d\d)} # when comparing two records that both contain 7X7, make sure all the digits (but not the dash) are equal
]
matcher = FuzzyMatch.new(faa_records, :identities => identities)
{% endhighlight %}

which produces the correct match

<pre>Boeing 737-200c         737-200, Surveiller (CT-43, VC-96)</pre>

### Rules and options ###

Check out the [`fuzzy_match` documentation](https://github.com/seamusabshere/fuzzy_match) for all the kinds of rules...

* `:blockings`
* `:normalizers`
* `:identities`
* `:stop_words`

and also options you can pass to `find`...

* `:read`
* `:must_match_blocking`
* `:must_match_at_least_one_word`
* `:first_blocking_decides`

That's it!

<!-- more end -->
