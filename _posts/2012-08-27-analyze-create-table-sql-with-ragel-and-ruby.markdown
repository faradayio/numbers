---
title: Analyze CREATE TABLE SQL with pure Ruby
author: Seamus
layout: post
categories: technology techresearch
---

You can use the new [<tt>create_table</tt> library](https://github.com/seamusabshere/create_table) to analyze and inspect CREATE TABLE statements (what is the primary key? what are the column data types? what are the defaults?) You can also generate SQL that works with different databases.

{% highlight irb %}
>> require 'create_table'
=> true
>> c = CreateTable.new(%{
  CREATE TABLE employees
  (employeeid INTEGER NOT NULL,
  lastname VARCHAR(25) NOT NULL,
  firstname VARCHAR(25) NOT NULL,
  reportsto INTEGER NULL); 
})
=> #<CreateTable>
>> c.columns.map(&:name)
=> ["employeeid", "lastname", "firstname", "reportsto"]
>> c.columns.map(&:data_type)
=> ["INTEGER", "CHARACTER VARYING(25)", "CHARACTER VARYING(25)", "INTEGER"]
>> c.columns.map(&:allow_null)
=> [false, false, false, true]
{% endhighlight %}

<!-- more start -->

(grabbed that example from the [About.com entry on CREATE TABLE SQL](http://databases.about.com/od/sql/a/tables_2.htm), thanks!)

### Uses Ragel for parsing

The library uses [Ragel](http://www.complang.org/ragel/) internally for parsing.

Check out the [column parser code](https://github.com/seamusabshere/create_table/blob/master/lib/create_table/column.rl), for example.

### Translates among MySQL, PostgreSQL, and SQLite3

Early versions target [MySQL](http://dev.mysql.com/doc/refman/5.1/en/create-table.html), [PostgreSQL](http://www.postgresql.org/docs/9.1/static/sql-createtable.html), and [SQLite](http://www.sqlite.org/lang_createtable.html).

{% highlight irb %}
>> require 'create_table'
=> true
>> c = CreateTable.new(%{
  CREATE TABLE cats (
    id INTEGER AUTO_INCREMENT, /* AUTO_INCREMENT with an underscore is MySQL-style... */
    nickname CHARACTER VARYING(255),
    birthday DATE,
    license_id INTEGER,
    price NUMERIC(5,2),
    PRIMARY KEY ("id")
  )
})
=> #<CreateTable>
>> c.to_mysql
=> ["CREATE TABLE cats ( `id` INTEGER PRIMARY KEY AUTO_INCREMENT, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2) )"]
>> c.to_postgresql
=> ["CREATE TABLE cats ( \"id\" SERIAL PRIMARY KEY, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2) )"]
>> c.to_sqlite3
=> ["CREATE TABLE cats ( \"id\" INTEGER PRIMARY KEY AUTOINCREMENT, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2) )"]
{% endhighlight %}

### Obviously there's a web service

You can POST statements to [http://create-table.herokuapp.com/statements](http://create-table.herokuapp.com/statements) and get the results back as JSON:

{% highlight console %}
$ curl -i -X POST -H "Accept: application/json" --data "CREATE TABLE cats ( id INTEGER AUTO_INCREMENT, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2), PRIMARY KEY (\"id\") )" http://create-table.herokuapp.com/statements
HTTP/1.1 201 Created
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
Date: Fri, 24 Aug 2012 22:24:52 GMT
Etag: "f13513b9126eb1fb909229e828c6a7cd"
Location: http://create-table.herokuapp.com/statements/9
Server: thin 1.4.1 codename Chromeo
X-Rack-Cache: invalidate, pass
X-Runtime: 0.051092
X-Ua-Compatible: IE=Edge,chrome=1
Content-Length: 1490
Connection: keep-alive

{"statement":{"original":"CREATE TABLE cats ( id INTEGER AUTO_INCREMENT, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2), PRIMARY KEY (\"id\") )","mysql":"CREATE TABLE cats ( `id` INTEGER PRIMARY KEY AUTO_INCREMENT, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2) )","postgresql":"CREATE TABLE cats ( \"id\" SERIAL PRIMARY KEY, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2) )","sqlite3":"CREATE TABLE cats ( \"id\" INTEGER PRIMARY KEY AUTOINCREMENT, nickname CHARACTER VARYING(255), birthday DATE, license_id INTEGER, price NUMERIC(5,2) )","columns":[{"name":"id","data_type":"INTEGER","allow_null":false,"default":null,"primary_key":true,"unique":true,"autoincrement":true,"charset":null,"collate":null},{"name":"nickname","data_type":"CHARACTER VARYING(255)","allow_null":true,"default":null,"primary_key":false,"unique":false,"autoincrement":false,"charset":null,"collate":null},{"name":"birthday","data_type":"DATE","allow_null":true,"default":null,"primary_key":false,"unique":false,"autoincrement":false,"charset":null,"collate":null},{"name":"license_id","data_type":"INTEGER","allow_null":true,"default":null,"primary_key":false,"unique":false,"autoincrement":false,"charset":null,"collate":null},{"name":"price","data_type":"NUMERIC(5,2)","allow_null":true,"default":null,"primary_key":false,"unique":false,"autoincrement":false,"charset":null,"collate":null}]}}
{% endhighlight %}

Submissions are recorded so that you can add errata to them&mdash;like [this one](http://create-table.herokuapp.com/statements/9#disqus_thread).

<!-- more end -->
