---
title: Browserify your JavaScript
author: Derek
layout: post
categories: technology
---

While working on [Careplane](http://careplane.org) recently, I ran into a problem that was made easier by [JSONPath](http://goessner.net/articles/JsonPath/). I was already enjoying the ability to test my JavaScript with [Node.js](http://nodejs.org), [Jasmine](), and other [npm](http://npmjs.org/) packages. It would be nice if I could get the same package system I have with npm and use it with my client-side JavaScript.

With [browserify](http://github.com/substack/node-browserify), now I can!

There are three major benefits to using browserify, which I'll detail below.

<!-- more start -->

# Using npm Modules in Your Client-Side Scripts

In Careplane, I wanted to use the [JSONPath npm package](). With browserify, I can write the following into my client-side code:

{% highlight javascript %}
  /* clientside.js */
  var jsonpath = require('JSONPath');
  var $ = require('jquery-browserify');
  
  var owned_data = jsonpath.eval(myData, '$.paths[*].to.data[?(@.owner == "Derek")]');
  $('p.important').html(owned_data);
{% endhighlight %}

From the command-line, I can create a single JavaScript file (I'll call it application.js) that contains my code and includes the JSONPath package. I can even bake jQuery into application.js!

{% highlight bash %}
  > npm install browserify
  > npm install JSONPath
  > npm install jquery-browserify
  > ./node_modules/.bin/browserify -r JSONPath -r jquery-browserify -e clientside.js -o application.js
{% endhighlight %}

Now that I have a nicely wrapped application.js, I can include it from a web page, or in this case, the browser plugin I'm developing.

Here's an example of use from a web page:

{% highlight html %}
  <script type="text/javascript" src="application.js"></script>
{% endhighlight %}

_N.B. Not all npm packages will work client-side, especially ones that depend on core Node.js modules like `fs` or `http`._

# Organize Your Code

Careplane has a ton of JavaScript split into a separate file for each class. Previously, I was using simple concatenation and a hand-crafted file list to construct an application.js and to determine script load order. Now it can be managed automatically by browserify because each of my class files can require other class files.

For instance, the Kayak class in `src/drivers/Kayak.js` depends on the Driver class in `src/Driver.js`. I can now do this:

{% highlight javascript %}
  /* src/Driver.js */

  var Driver = function() {};

  /* ... */

  module.exports = Driver;
{% endhighlight %}

{% highlight javascript %}
  /* src/Kayak.js */
  var Driver = require('../Driver')

  var Kayak = function(foo) { this.foo = foo; };
  Kayak.prototype = new Driver();
  
  /* ... */
  
  module.exports = Kayak;
{% endhighlight %}

{% highlight javascript %}
  /* src/main.js */
  
  var Kayak = require('./drivers/Kayak'); // paths are relative to src, main.js' cwd
  
  Kayak.getThePartyStarted();
{% endhighlight %}

{% highlight bash %}
  > ./node_modules/.bin/browserify -e src/main.js -o application.js
{% endhighlight %}

Super simple!

# Uniformity With Testing Environment

I like to run my [Jasmine](http://pivotal.github.com/jasmine/) JavaScript tests from the command-line and so does our [Continuous Integration](http://martinfowler.com/articles/continuousIntegration.html) system. With [jasmine-node](http://github.com/mhevery/jasmine-node), I had to maintain a list of files in my src directory that were loaded in a certain order in order to run my tests. Now, each spec file can use Node.js' CommonJS `require` statement to require files from my src directory, and all dependencies are automatically managed.

{% highlight javascript %}
  /* spec/javascripts/drivers/KayakSpec.js */
  
  describe('Kayak', function() {
    var Kayak = require('src/drivers/Kayak');
    /* ... */
  });
{% endhighlight %}

{% highlight bash %}
  > rake examples[KayakSpec] 
  Starting tests
  ............FFF............FF
{% endhighlight %}

When I run my specs from the command-line with Node.js (I have an `examples` rake task that runs node and jasmine), Node's built-in CommonJS `require` is used and it recognizes the `require` statements I wrote into src/drivers/Kayak.js.

I can also run my Jasmine specs from the standard Jasmine web server. All I have to do is create a browserified script that is included before Jasmine runs its tests in my browser.

{% highlight javascript %}
  /* src/jasmine.js */
  var Kayak = require('./drivers/Kayak');  // browserify needs a starting point to resolve all dependencies
{% endhighlight %}

{% highlight yaml %}
  # spec/javascripts/support/jasmine.yml
  src_files:
    - spec/javascripts/support/application.js
{% endhighlight %}

{% highlight bash %}
  > ./node_modules/.bin/browserify -e src/jasmine.js -o spec/javascripts/support/application.js
  > rake jasmine:server
  your tests are here:
    http://localhost:8888/
  [2011-08-04 16:15:56] INFO  WEBrick 1.3.1
  [2011-08-04 16:15:56] INFO  ruby 1.9.2 (2011-02-18) [x86_64-darwin10.4.0]
  [2011-08-04 16:15:56] INFO  WEBrick::HTTPServer#start: pid=61833 port=8888
{% endhighlight %}

When I visit http://localhost:8888 in my browser, my Jasmine tests all run!

The only drawback is that my code has to be re-browserified whenever it changes. This only adds about a second of overhead while I wait for my [watchr](http://rubygems.org/gems/watchr) script to run the browserification.

# More

If you'd like to take a look at the environment I set up for Careplane, you can check out the [source](http://github.com/brighterplanet/careplane).

I hope you enjoy browserify as much as I have!

<!-- more end -->
