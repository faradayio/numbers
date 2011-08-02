---
title: "Introducing Bombshell: custom interactive consoles for your Ruby libraries"
author: Andy
layout: post
categories: technology techresearch
---

One of the cool features of [`carbon`](http://github.com/brighterplanet/carbon), the Ruby library for our [CM1](http://carbon.brighterplanet.com) web service, is its built-in interactive console for experimenting with the service. At Brighter Planet we use `carbon`'s console all the time to construct one-off calculations and perform simple analyses.

<!-- more start -->

We think the built-in library console could be a pretty useful pattern for other libraries; they allow developers to explore your library and its API without having to contrive host applications just to test things out.

Building `carbon`'s console, however, was a major pain. IRB, the console's basis, is infamous for its poor documentation and, with all due respect, antiquated API. So we extracted all the little tricks and nuances that went into `carbon`'s console and put them in a library.

That library is [Bombshell](http://github.com/rossmeissl/bombshell). To use it, just create a class for the console in your library and hook it into Bombshell. Instance methods on your class are "commands" in your console:

{% highlight ruby %}
module FooGem
  class Shell < Bombshell::Environment
    include Bombshell::Shell
    prompt_with 'fooshell'
    def report
      puts FooGem::Foo.new.report! # Do something with your library here
    end
  end
end
{% endhighlight %}

{% highlight console %}
fooshell> report
All is well!
{% endhighlight %}

Bombshell provides callback hooks, supports arbitrary-depth subshells, and handles tab-completion automatically.

Check out the [README](https://github.com/rossmeissl/bombshell#readme), the [docs](http://rubydoc.info/github/rossmeissl/bombshell/master/frames), and `carbon`'s [shell class](https://github.com/brighterplanet/carbon/blob/master/lib/carbon/shell.rb) (and [subshell](https://github.com/brighterplanet/carbon/blob/master/lib/carbon/shell/emitter.rb)) for a more complex (production) example.

Thanks to [Aslak Hellesøy](https://github.com/aslakhellesoy), whose [`aruba`](https://github.com/aslakhellesoy/aruba) Cucumber steps made it possible to write a pretty thorough test suite for Bombshell.

<!-- more end -->
