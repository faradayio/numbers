---
title: What you should know about mysql2 memory usage
author: Seamus
layout: post
categories: technology
---

If you're using [mysql2](http://rubygems.org/gems/mysql2), you should be aware of a memory usage issue:

{% highlight ruby %}
# mysql2 gem - no way to avoid using a lot of memory if you're streaming a lot of rows
client = Mysql2::Client.new(:host => "localhost", :username => "root")
results = client.query("SELECT * FROM users WHERE group='githubbers'")

# mysql gem - keep memory usage flat if you're streaming a lot of rows
dbh = Mysql.init
dbh.connect "localhost", "root"
dbh.query_with_result = false
dbh.query("SELECT * FROM users WHERE group='githubbers'")
results = dbh.use_result
{% endhighlight %}

While working on our [reference data web service](http://data.brighterplanet.com), I ran these benchmarks:

* Exporting 5,000 rows using <tt>mysql</tt> (the "old" gem) [stays flat on memory](https://github.com/seamusabshere/mysql2xxxx/blob/master/benchmark/results/0.0.4-20110314190640.txt)
* Exporting 5,000 rows using <tt>mysql2</tt> [takes an ever-increasing amount of memory](https://github.com/seamusabshere/mysql2xxxx/blob/master/benchmark/results/0.0.3-20110314160922.txt) (not good!)

### The problem ###

The author of the gem in question, [mysql2](http://rubygems.org/gems/mysql2), knows about [the issue](https://github.com/brianmario/mysql2/issues/87). In a nutshell, the gem's use of <code>mysql_store_result</code> (as opposed to <code>mysql_use_result</code>) leads the underlying <tt>libmysql</tt> library to always load entire resultsets into memory... <strong>even</strong> if <code>:cache_rows => false</code> is passed as a runtime option. A <code>:streaming => true</code> option would make perfect sense!

### The solution ###

* I had to modify my gem, [mysql2xxxx](http://rubygems.org/gems/mysql2xxxx) (which provides <tt>mysql2csv</tt>, <tt>mysql2json</tt>, and <tt>mysql2xml</tt>) to use the "old" <tt>mysql</tt> gem.
* If you're using <tt>mysql2</tt> (it's the default on Rails 3!) then be aware that processing huge resultsets has a different memory impact than it did with <tt>mysql</tt>.
* Vote up [the issue](https://github.com/brianmario/mysql2/issues/85) on github... it would be nice to optionally use <code>mysql_use_result</code>!

I believe <tt>mysql2</tt> has a promising future and this memory problem will probably be gone soon. Thanks [<tt>brianmario</tt>](https://github.com/brianmario)!
