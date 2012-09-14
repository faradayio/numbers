---
title: Upsert for MySQL, PostgreSQL, and SQLite3 (and Ruby)
author: Seamus
layout: post
categories: technology techresearch
---

Our [`upsert`](https://github.com/seamusabshere/upsert) library for Ruby gives you NoSQL-like `upsert` functionality in traditional RDBMS databases. How?

* MySQL's native [`INSERT ... ON DUPLICATE KEY UPDATE`](http://dev.mysql.com/doc/refman/5.5/en/insert-on-duplicate.html)
* PostgreSQL's canonical [`CREATE FUNCTION merge_db`](http://www.postgresql.org/docs/9.1/static/plpgsql-control-structures.html#PLPGSQL-UPSERT-EXAMPLE)
* SQLite3's [`INSERT OR IGNORE`](http://www.sqlite.org/lang_insert.html) plus a trailing `UPDATE` statement

### 50%--80% faster than ActiveRecord

**New in 0.4.0**: When used in PostgreSQL mode, database functions are re-used, so you don't have to be in batch mode to get the speed advantage.

You **don't** need [ActiveRecord](http://api.rubyonrails.org/classes/ActiveRecord/Base.html) to use it, but it's benchmarked against ActiveRecord and found to be up to 50% to 80% faster than traditional techniques for emulating upsert:

{% highlight console %}
# postgresql (pg library)
Upsert was 78% faster than find + new/set/save
Upsert was 78% faster than find_or_create + update_attributes
Upsert was 88% faster than create + rescue/find/update

# mysql (mysql2 library)
Upsert was 46% faster than find + new/set/save
Upsert was 63% faster than find_or_create + update_attributes
Upsert was 74% faster than create + rescue/find/update
Upsert was 28% faster than faking upserts with activerecord-import (which uses ON DUPLICATE KEY UPDATE)

# sqlite3
Upsert was 72% faster than find + new/set/save
Upsert was 74% faster than find_or_create + update_attributes
Upsert was 83% faster than create + rescue/find/update
{% endhighlight %}

(run the tests on your own machine to get these benchmarks)

<!-- more start -->

### What is a selector? What is a document?

`upsert` was inspired by the MongoDB upsert method &ndash; AKA [mongo-ruby-driver's update method](http://api.mongodb.org/ruby/1.6.4/Mongo/Collection.html#update-instance_method) &ndash; and involves a "selector" (how to find the row to be inserted or updated) and a "document" (attributes that should be set once the record has been found.)

#### Example 1

* Selector: `:name => 'Jerry'`
* Document: `:age => 5`
* Expression: `upsert.row({:name => 'Jerry'}, :age => 5)`

#### Example 2

* Selector: `:id => 45`
* Document: `:updated_at => Time.now`
* Expression: `upsert.row({:id => 45}, :updated_at => Time.now)`

Unfortunately, you currently **can't** do things like `:counter => 'counter + 1'`.

### Quickstart

One record at a time:

{% highlight ruby %}
connection = Mysql2::Client.new([...])
upsert = Upsert.new connection, 'pets'
upsert.row({:name => 'Jerry'}, :breed => 'beagle')
{% endhighlight %}

With ActiveRecord helper: (first `require 'upsert/active_record_upsert'`)

{% highlight ruby %}
Pet.upsert({:name => 'Jerry'}, :breed => 'beagle')
{% endhighlight %}

In batch mode, which is the fastest:

{% highlight ruby %}
connection = Mysql2::Client.new([...])
Upsert.batch(connection, 'pets') do |upsert|
  upsert.row({:name => 'Jerry'}, :breed => 'beagle')
  upsert.row({:name => 'Pierre'}, :breed => 'tabby')
end
{% endhighlight %}

<!-- more end -->
