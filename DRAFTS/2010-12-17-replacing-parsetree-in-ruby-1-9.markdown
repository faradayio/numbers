---
title: Replacing ParseTree in Ruby 1.9
author: Seamus
layout: post
categories: [technology]
---

[ParseTree](http://parsetree.rubyforge.org/ParseTree/) doesn't work with Ruby 1.9.2, but we fixed the problem by using [sourcify](https://github.com/ngty/sourcify).

{% highlight ruby %}
## BEFORE
# gem 'ParseTree', '3.0.5', :require => false
# require 'parse_tree'
# require 'parse_tree_extensions'

## AFTER
gem 'sourcify', '~>0.4.0'
gem 'ruby_parser'
gem 'file-tail'
{% endhighlight %}

We replaced ParseTree's <tt>Proc#to_ruby</tt> with sourcify's <tt>Proc#to_source</tt>.

{% highlight ruby %}
## BEFORE
# def show_quorum_source(quorum)
#   proc = quorum.process
#   proc.to_ruby
# end

## FIRST TRY (usually enough, but for us raised NoMatchingProcError or MultipleMatchingProcsPerLineError)
# def show_quorum_source(quorum)
#   proc = quorum.process
#   proc.to_source
# end

## SECOND TRY (works for us)
def show_quorum_source(quorum)
  proc = quorum.process
  # Note that :attached_to takes a symbol
  proc.to_source :attached_to => :quorum
end
{% endhighlight %}

We needed to pass the <tt>:attached_to</tt> option because our [carbon model DSL](https://github.com/brighterplanet/flight/blob/master/lib/flight/carbon_model.rb) has multiply nested procs and we would get <tt>NoMatchingProcError</tt> or <tt>MultipleMatchingProcsPerLineError</tt>:

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

We told sourcify's author, [Ng Tze Yang](https://github.com/ngty), and he added the <tt>:attached_to</tt> option. Thanks to him for all his work!
