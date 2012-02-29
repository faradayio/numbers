---
title: Beware of String#hash being used for cache keys...
author: Seamus
layout: post
categories: technology
---

Every process will have a __different hash value for the same string__, so cache keys based on `String#hash` will not work as expected!

{% highlight ruby %}
$ irb
1.9.3-p0 :001 > 'test'.hash
 => 240227015057187339 
1.9.3-p0 :002 > 'test'.hash
 => 240227015057187339 
1.9.3-p0 :003 > exit
$ irb
1.9.3-p0 :001 > 'test'.hash
 => -2779337368972820904 
1.9.3-p0 :002 > 'test'.hash
 => -2779337368972820904 
{% endhighlight %}

All calls to plain vanilla `Object#hash` have the same problem. It turns out it's intentional...

<!-- more start -->

... as [explained by Yui Naruse](http://www.ruby-forum.com/topic/560622):

    It is intended. Ruby 1.9 explicitly use session local random seed to calculate a hash for strings (and some other objects).

... just not mentioned in [the core Ruby docs for `String#hash`](http://www.ruby-doc.org/core-1.9.3/String.html#method-i-hash), which say:

    Return a hash based on the string’s length and content.

There is a [7-month old pull request from FND to fix the docs](https://github.com/ruby/ruby/pull/43)... let's hope it gets merged soon to prevent further confusion!

<!-- more end -->
