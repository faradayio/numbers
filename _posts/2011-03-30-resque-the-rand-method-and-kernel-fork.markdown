---
title: Resque, the rand() method, and Kernel.fork
author: Seamus
layout: post
categories: technology techresearch
---

We had a seemingly impossible number of tmpdir collisions once we switched our [reference data web service](http://data.brighterplanet.com) from [DelayedJob](https://github.com/collectiveidea/delayed_job) to [Resque](https://github.com/defunkt/resque).

The culprit was calling <code>rand()</code> in worker processes that are forked off the main process by Resque:

{% highlight ruby %}
$ irb
> Kernel.fork { puts rand.to_s }
  0.536506566371644
> Kernel.fork { puts rand.to_s }
  0.536506566371644              # the same
> Kernel.fork { puts rand.to_s }
  0.536506566371644              # the same
{% endhighlight %}

Don't forget to call <code>srand</code>!

{% highlight ruby %}
$ irb
> Kernel.fork { srand; puts rand.to_s }
  0.232438861240513
> Kernel.fork { srand; puts rand.to_s }
  0.363543277594837
> Kernel.fork { srand; puts rand.to_s }
  0.000133387538081786
{% endhighlight %}

Now it's fixed in the [remote_table gem](https://github.com/seamusabshere/remote_table) via [this commit](https://github.com/seamusabshere/remote_table/commit/9d0d99872171eb9e310aeccf2349f9f6559fb760).
