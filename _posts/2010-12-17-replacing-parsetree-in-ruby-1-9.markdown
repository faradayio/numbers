---
title: How we replaced ParseTree in Ruby 1.9
author: Seamus
layout: post
categories: [technology]
---

Like many Ruby shops, we took for granted [ParseTree](http://parsetree.rubyforge.org/ParseTree/)'s ability to show the source code of pretty much any object. As [previously explained](http://blog.zenspider.com/2009/04/parsetree-eol.html), however, ParseTree doesn't work with Ruby 1.9.2. We fixed the problem by using [sourcify](https://github.com/ngty/sourcify).

{% highlight ruby %}
## DOESN'T WORK IN RUBY 1.9
gem 'ParseTree', :require => false
require 'parse_tree'
require 'parse_tree_extensions'

## WORKS IN RUBY 1.9
gem 'sourcify'
gem 'ruby_parser'
gem 'file-tail'
{% endhighlight %}

In particular, we replaced ParseTree's <tt>Proc#to_ruby</tt> with sourcify's <tt>Proc#to_source</tt>.

{% highlight ruby %}
## The old ParseTree way
proc.to_ruby
## The sourcify way - but raised NoMatchingProcError or MultipleMatchingProcsPerLineError
proc.to_source
## The sourcify way - giving :attached_to a symbol to help it find the correct Proc
proc.to_source :attached_to => :quorum
{% endhighlight %}

We needed to pass the <tt>:attached_to</tt> option because our [carbon calculation code](https://github.com/brighterplanet/flight/blob/master/lib/flight/carbon_model.rb) has multiply nested procs and we would get <tt>NoMatchingProcError</tt> or <tt>MultipleMatchingProcsPerLineError</tt>:

{% highlight ruby %}
committee :distance do
  quorum 'from airports' do
    # [...]
  end
  quorum 'from cohort' do
    # [...]
  end
  quorum 'default' do
    # [...]
  end
end
{% endhighlight %}

Thanks to sourcify's author, [Ng Tze Yang](https://github.com/ngty), who added the <tt>:attached_to</tt> option when we showed him the problem. It made it possible to migrate our [emission estimate web service](http://carbon.brighterplanet.com), which comes with detailed [carbon calculation methodology reports](http://carbon.brighterplanet.com/flights?destination_airport[iata_code]=SFO&origin_airport[iata_code]=JAC), to Ruby 1.9! 
