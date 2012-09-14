---
title: Back to the Browser\: A JavaScript Workflow for UNIX Nerds
author: derek
layout: post
categories: technology
---

When Apple announced Mac OS X Lion, their tagline was "Back to the Mac" as they were bringing some features from iOS into the desktop-oriented Mac OS. In the JavaScript world, a similar thing has happened: innovations in the [Node.js](http://nodejs.org/) space can be brought back to the browser. These innovations have made JavaScript development faster and cleaner with command-line tools and the npm packaging system.

<!-- more start -->

As I began writing serious JavaScript libraries and apps, I wanted the same kind of workflow I enjoy when writing Ruby code. I wanted to write my code in vi, run tests in the command line, organize my code into classes/modules, and use versioned packages similar to Ruby gems. At the time, the standard way to write JavaScript was to manage separate files by hand and concatenate them into a single file. One of the only testing frameworks in town was Jasmine, which required you to run tests in the browser. Since then, there has been an explosion of code packaging and testing frameworks. What follows is the approach I find to be the most productive.

Here's a list of the tools that correspond to their Ruby world counterparts:

| Application          | Ruby                            | Javascript                                               |
| -------------------- | ------------------------------- | -------------------------------------------------------- |
| Testing              | [RSpec](http://rspec.info)      | [vows](http://vowsjs.org), [buster](http://busterjs.org) |
| Package management   | [rubygems](http://rubygems.org) | npm                                                      |
| Modules/organization | require                         | [CommonJS](http://commonjs.org) |
| Build tools  | jeweler, rubygems | [browserify](http://github.com/substack/node-browserify) |

By installing Node.js, you have access to a command-line JavaScript runtime, testing, package management, and application building. Running tests from the command-line allows you to more easily use tools like [guard](http://rubydoc.info/gems/guard/frames), run focused unit tests, and easily set up continuous integration.

### Testing

Many JavaScripters run Jasmine in the browser for testing. While it was good for its time, it is now comparatively verbose and doesn't fit well within the CommonJS module system. Instead of Jasmine I prefer vows or buster.js. Each supports a simpler "hash" based syntax, as opposed to Jasmine's verbose syntax:

{% highlight javascript %}
// Jasmine

describe('MyClass', function() {
  before(function() {
    this.instance = new MyClass('foo');
  });
  
  describe('#myMethod', function() {
    it('returns true', function() {
      expect(this.instance.myMethod()).toBe(true);
    });
  });
});
{% endhighlight %}


{% highlight javascript %}
// Vows

vows.describe('MyClass').addBatch({
  topic: new MyClass('foo'),

  '#myMethod': {
    'returns true': function(instance) {
      assert(instance.myMethod());
    }
  }
}).export(module);
{% endhighlight %}

I should note that buster supports both Jasmine's syntax and the hash-based syntax found in vows.

Vows and buster can be used just like `rspec` to run tests from the command line:

    > vows test/my-class-test.js
    ................
    OK >> 22 honored

For mocks and stubs, you can use [sinon](http://sinonjs.org), which is included by default with buster.js.

#### Integration testing

In addition to unit testing, it's always good run a full integration test. You can either run tests from vows or buster with a simulated browser environment like [zombie.js](http://zombie.labnotes.org/).

Since every browser has its own quirks, it's best to run integration tests in each browser. This can be accomplished using [capybara](http://jnicklas.github.com/capybara/) with any Ruby test framework. Capybara can drive any browser with [selenium](http://seleniumhq.org/) and you can test webkit browsers headlessly with [capybara-webkit](https://github.com/thoughtbot/capybara-webkit).

### Package management

One of the joys of Ruby is its package manager, rubygems. With a simple `gem install` you can add a library to your app. There has been an explosion of JavaScript package managers lately. Each one adds the basic ability to gather all of your libraries and application code, resolve the dependencies, and concatenate them into a single application file. They can be grouped into three basic categories:

#### Simple concatenators

The earliest sorts of package managers, like [Sprockets](https://github.com/sstephenson/sprockets#readme) and [Stitch](https://github.com/maccman/stitch-rb) would require you to download release versions of libraries like jQuery and place them in your project. The concatenator would then prepend the library code before your application code. This approach lacks an automated process to download and update each library and requires static copies of each library in your application.

#### Wrappers

Here, JavaScript libraries are wrapped inside other languages' packaging systems, like rubygems. This is the approach that Rails' [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) and [BPM](http://getbpm.org/) take. The main disadvantage with this approach is that any JavaScript package you'd want to use would need a gem wrapper that would have to be kept up to date. Thus, only a few popular libraries like jQuery and underscore are available.

[Bower](http://twitter.github.com/bower/) (similar to [Volo](http://volojs.org/)) was recently released by the folks at Twitter. This system requires each library maintainer to define a component.json file in their project, leading to the same problem as above.

#### Npm extensions

Many recent package managers piggyback on top of Node's npm/CommonJS module system. In the Node.js world, you can add packages to your application with the `npm install` command just as easily as with rubygems. It makes a lot of sense to use npm for client-side JavaScript package management. However, since not all npm packages will work in the browser (they may use V8 or Node.js-specific APIs), many of these piggybacked systems either restrict you to a subset of packages tagged specifically for that package manager, or they come with the caveat that you need to make sure all npm packages you use are client-side compatible. [Ender.js](http://ender.no.de/), Spine.js' [hem](http://spinejs.com/docs/hem), and most recently, [jam](http://jamjs.org/) are popular examples.

### Browserify - the transcendent package manager

I settled early on [browserify](https://github.com/substack/node-browserify) as my package manager of choice. It allows me to use npm modules in my app, just as if I was developing a Node.js app. Browserify adds a compatibility layer to your client side code, so that any calls to Node-specific APIs work in the browser. This means any package written for Node will work in the browser (with the exception of packages using file system and socket libraries). There is a plethora of modules that I use regularly, like `JSONPath` for JSON processing, `replay` for mocking HTTP (AJAX) requests (similar to Ruby's [vcr](https://www.relishapp.com/myronmarston/vcr/v/2-2-5/docs/)), and `async` for simplified asynchronous flow control.

Browserify brings node's CommonJS module system to the browser. It will encourage you to organize your code into CommonJS modules.

The disadvantage of a "pure" CommonJS approach is that many client-side libraries are written with global `window` and `document` objects in mind. You can stub these out in your test helper using jsdom.  The other disadvantage is that a library you need may not be published as an npm package. I haven't yet run into this problem (in fact, I've found more packages on npm than I knew existed), but browserify can be configured to include any static library files you need.

#### Bundler-like dependency management

A typical Ruby gem or Rails app uses bundler to define and load dependencies. In the JavaScript world (using browserify), this can be done with npm. Simply place a `package.json` file in your application's root as if you were developing an npm module. In that file, add "dependencies" and "devDependencies" keys that list each npm package and version your app needs. On the command line, use `npm install` to install them. That's it, no special, client-side package manager-specific file needed.

#### Sidebar: CommonJS vs RequireJS/AMD

CommonJS has a more flexible module API that's an improvement over AMD. That is, you can manipulate the module and module.exports objects to provide access to load paths and other things. It also frees you from worrying about namespace conflicts. With CommonJS in browserify, your module names are just file names. Other module names used by your included packages are also file path names.

### Code organization

As JavaScript applications get more complex, it becomes prudent to split your code into separate modules, usually placed in separate files. In the Ruby world, this was easily done by `require`-ing each file. By using browserify you can split your own code into modules -- which may contain a class or a set of functions -- each placed in its own file.

#### Ruby structure

For example, my Ruby project may look like:

    ~lib/
     -my_library.rb
     -my_library/
       -book.rb
    -my_library.gemspec
    -spec/
     -my_library/
       -book_spec.rb

Where `lib/my_library.rb` looks like:

{% highlight ruby %}
require 'my_library/book'

class MyLibrary
  def initialize(foo)
    @book = Book.parse(foo)
  end
end
{% endhighlight %}

And `lib/my_library/book.rb` looks like:

{% highlight ruby %}
require 'jsonpath'

class MyLibrary
  class Book
    def self.parse(foo)
      JSONPath.eval(foo, '$.store.book\[0\]')
    end
  end
end
{% endhighlight %}

And `spec/my_library/book_spec.rb` looks like:

{% highlight ruby %}
require 'json'
require 'helper'
require 'my_library/book'

describe MyLibrary::Book do
  describe '.parse' do
    it 'parses a book object' do
      json = File.read('support/book.json')
      book = Book.parse(JSON.parse(json))
      book.title.should == "Breakfast at Tiffany's"
    end
  end
end
{% endhighlight %}

#### JavaScript structure

A javascript project would look similar:

    ~lib/
     -my-library.js
     -my-library/
       -book.js
    -package.json
    -test/
     -my-library/
       -book-test.js

Where `lib/my-library.js` looks like:

{% highlight javascript %}
var Book = require('./my-library/book');

var MyLibrary = function(foo) {
  this.book = new Book(foo);
};

module.exports = MyLibrary;
{% endhighlight %}

And `lib/my-library/book.js` looks like:

{% highlight javascript %}
var jsonpath = require('jsonpath');

var Book = {
  parse: function(foo) {
    return jsonpath(foo, '$.store.book\[0\]');
  }
};

module.exports = Book;
{% endhighlight %}

And `test/my-library/book-test.js` looks like:

{% highlight javascript %}
var fs = require('fs');
var helper = require('../helper'),
    Book = require('../../lib/my_library/book');
    // NOTE: there are ways to set up your modules 
    // to be able to use relative require()s but
    // it is beyond the scope of this article

vows.describe('Book').addBatch({
  '.parse': {
    'parses a book object': function() {
      var json = fs.readFileSync('support/book.json'),
          book = Book.parse(JSON.parse(json));
      assert.equal(book.title, "Breakfast at Tiffany's");
    }
  }
}).export(module);
{% endhighlight %}

At build/deploy time, browserify will combine all your lib code into a single JavaScript file, which can be included on a web page.

Altogether, npm packages, command-line testing and build tools, and modular code organization help you quickly build non-trivial JavaScript libraries and applications just as easily as it was in Ruby land. I've developed several in-production projects using this workflow, such as our [CM1](http://github.com/dkastner/CM1.js) JavaScript client library, our flight search [browser plugin](http://github.com/brighterplanet/careplane), and [hootroot.com](http://github.com/brighterplanet/hootroot1).

<!-- more end -->
