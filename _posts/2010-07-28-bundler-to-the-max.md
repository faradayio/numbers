---
title: Bundler to the Max
author: Derek
layout: post
categories: [ruby, bundler, gems]
---

I have been spending the past few weeks creating and refactoring our [carbon model gems](http://carbon.brighterplanet.com/science), with the goal of making them easy to enhance, fix, and test by climate scientists and Ruby developers. I wanted to make contributing a simple process and [bundler](http://rubybundler.com) fit the bill quite well.

A not-so-widely-known feature of the [Rubygems](http://rubygems.org) API is the ability to declare a gem's development dependencies, along with its runtime dependencies. If one planned on making changes to one of the emitter gems and testing it, she could run `gem install <emitter_gem> --development` and have any needed testing gems installed for the emitter gem.

This is all fine and good, but I chose to use bundler to manage our dependencies, as it adds a few extras that have been a tremendous help to us. To contribute to any of our gems, a developer can follow a simple process:

{% highlight console %}
$ git clone git://github.com/brighterplanet/<gem>.git
$ cd <gem>
$ gem install bundler --pre  # this is needed until bundler 1.0 is released
$ bundle install
$ rake
{% endhighlight %}

And Bob's your uncle!

### Bundler + Gemspecs
The first goodie that bundler provides is the ability to use the gem's own gemspec to define the dependencies needed for development. For instance, our flight gem has a gemspec with dependencies:

{% highlight ruby %}
Gem::Specification.new do |s|
  # ...
  s.add_development_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
  s.add_development_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
  s.add_development_dependency(%q<cucumber>, ["= 0.8.3"])
  s.add_development_dependency(%q<jeweler>, ["= 1.4.0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<rdoc>, [">= 0"])
  s.add_development_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
  s.add_development_dependency(%q<sniff>, ["= 0.0.10"])
  s.add_runtime_dependency(%q<characterizable>, ["= 0.0.12"])
  s.add_runtime_dependency(%q<data_miner>, ["= 0.5.2"])
  s.add_runtime_dependency(%q<earth>, ["= 0.0.7"])
  s.add_runtime_dependency(%q<falls_back_on>, ["= 0.0.2"])
  s.add_runtime_dependency(%q<fast_timestamp>, ["= 0.0.4"])
  s.add_runtime_dependency(%q<leap>, ["= 0.4.1"])
  s.add_runtime_dependency(%q<summary_judgement>, ["= 1.3.8"])
  s.add_runtime_dependency(%q<timeframe>, ["= 0.0.8"])
  s.add_runtime_dependency(%q<weighted_average>, ["= 0.0.4"])
  # ...
end
{% endhighlight %}

Instead of defining these dependencies in both flight.gemspec and in Gemfile, we can instead give the following directive in our Gemfile:

{% highlight ruby %}
gemspec :path => '.'
{% endhighlight %}

### Bundler + Paths

We have a chain of gem dependencies, where an emitter gem depends on the sniff gem for development, which in turn depends on the earth gem for data models. In the olden days (like, 4 months ago) if I made a change to sniff, I would have to rebuild the gem and reinstall it. With bundler, I can simply tell my emitter gem to use a path to my local sniff repo as the gem source:

{% highlight ruby %}
gem 'sniff', :path => '../sniff'
{% endhighlight %}

Now, any changes I make to sniff instantly appear in the emitter gem!

I had to add some special logic (a hack, if you will) to my gemspec definition for this to work, because the above gem statement in my Gemfile would conflict with the dependency listed in my gemspec (remember, I'm using my gemspec to tell bundler what gems I need). To get around this, I added an if clause to my gemspec definition that checks for an environment variable. If this variable exists, the gemspec will not request the gem and bundler will instead use my custom gem requirement that uses a local path:

{% highlight ruby %}
# Rakefile  (we use jeweler to generate our gemspecs)
Jeweler::Tasks.new do |gem|
  # ...
  gem.add_development_dependency 'sniff', '=0.0.10' unless ENV['LOCAL_SNIFF']
  # ...
end
{% endhighlight %}

{% highlight ruby %}
# Gemfile
gem 'sniff', :path => ENV['LOCAL_SNIFF'] if ENV['LOCAL_SNIFF']
{% endhighlight %}

So now, if I want to make some changes to the sniff gem and test them out in my emitter, I do:

{% highlight console %}
$ cd sniff
  # work work work
$ cd ../[emitter]
$ export LOCAL_SNIFF=~/sniff
$ rake gemspec
$ bundle update
  # ...
sniff (0.0.13) using path /Users/dkastner/sniff
  # ...
{% endhighlight %}

And then Bob is my uncle.

### Bundler + Rakefile

This next idea has some drawbacks in terms of code cleanliness, but I think it offers a good way to point contributers in the right direction. One thing that frustrated me about Jeweler was that if I wanted to contribute to a gem, my typical work flow went like:

{% highlight console %}
$ cd [project]
  # work work work
$ rake test
LoadError: No such file: 'jeweler'
$ gem install jeweler
$ rake test
LoadError: No such file: 'shoulda'
  # etc etc
{% endhighlight %}

I attempted to simplify this process, so a new developer who doesn't read the README should be able to just do:

{% highlight console %}
$ cd [emitter]
  # work work work
$ rake test
You need to `gem install bundler` and then run `bundle install` to run rake tasks
$ gem install bundler
$ bundle install
$ rake test
All tests pass!
{% endhighlight %}

I achieved this by adding the following code to the top of the Rakefile:

{% highlight ruby %}
require 'rubygems'
begin
  require 'bundler'
  Bundler.setup
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
{% endhighlight %}

This was convenient, but it created a chicken and egg problem: in order to generate a gemspec for the first time, bundler needed to know which dependencies it needed, which meant that it needed the gemspec, which is generated by the Rakefile, which requires bundler, which requires the gemspec, etc. etc. I overcame this problem by allowing an override:

{% highlight ruby %}
require 'rubygems'
unless ENV['NOBUNDLE']
  begin
    require 'bundler'
    Bundler.setup
  rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end
{% endhighlight %}
So, if you're really desparate, you can run `rake test NOBUNDLE=true`

### More on Local Gems

Now that I had a way to easily tell bundler to use an actual gem or a local repo holding the gem, I wanted a way to quickly "flip the switch." I wrote up a quick function in my ~/.bash_profile:

{% highlight bash %}
function mod_devgem() {
  var="LOCAL_`echo $2 | tr 'a-z' 'A-Z'`"

  if [ "$1" == "disable" ]
  then
    echo "unset $var"
    unset $var
  else
    dir=${3:-"~/$2"}
    echo "export $var=$dir"
    export $var=$dir
  fi
}

function devgems () {
  # Usage: devgems [enable|disable] [gemname]
  cmd=${1:-"enable"}

  if [ "$1" == "list" ]
  then
    env | grep LOCAL
    return
  fi

  if [ -z $2 ]
  then
    mod_devgem $cmd characterizable
    mod_devgem $cmd cohort_scope
    mod_devgem $cmd falls_back_on
    mod_devgem $cmd leap
    mod_devgem $cmd loose_tight_dictionary
    mod_devgem $cmd sniff
    mod_devgem $cmd data_miner
    mod_devgem $cmd earth
  else
    mod_devgem $cmd $2
  fi
}
{% endhighlight %}

This gives me a few commands:

{% highlight console %}
$ devgems enable sniff
  # sets LOCAL_SNIFF=~/sniff
$ devgems disable sniff
  # clears LOCAL_SNIFF
$ devgems list
  # lists each LOCAL_ environment variable
{% endhighlight %}

I now have a well-oiled gem development machine!

Overall, after a few frustrations with bundler, I'm now quite happy with it, especially the power and convenience it gives me in developing gems.

I'm really interested to hear any of your thoughts on this. Drop me a line at [@dkastner](http://twitter.com/dkastner).
