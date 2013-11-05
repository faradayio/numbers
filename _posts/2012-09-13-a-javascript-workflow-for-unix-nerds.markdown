---
title: Back to the Browser - A JavaScript Workflow for UNIX Nerds
author: derek
layout: post
categories: technology
---

When Apple announced Mac OS X Lion, their tagline was "Back to the Mac" as they were bringing some features from iOS into the desktop-oriented Mac OS. In the JavaScript world, a similar thing has happened: innovations in the [Node.js](http://nodejs.org/) space can be brought back to the browser. These innovations have made JavaScript development faster and cleaner with command-line tools and the npm packaging system.

<!-- more start -->

As I began writing serious JavaScript libraries and apps, I wanted the same kind of workflow I enjoy when writing Ruby code. I wanted to write my code in vi, run tests in the command line, organize my code into classes and modules, and use versioned packages similar to Ruby gems. At the time, the standard way to write JavaScript was to manage separate files by hand and concatenate them into a single file. One of the only testing frameworks in town was Jasmine, which required you to run tests in the browser. Since then, there has been an explosion of command-line code packaging and testing frameworks in the Node.js community that have lent themselves well to client side development. What follows is the approach I find to be the most productive.

Here's a list of the tools that correspond to their Ruby world counterparts:

| Application          | Ruby                            | Javascript                                               |
| -------------------- | ------------------------------- | -------------------------------------------------------- |
| Testing              | [RSpec](http://rspec.info)      | [vows](http://vowsjs.org), [buster](http://busterjs.org) |
| Package management   | [rubygems](http://rubygems.org), [bundler](http://gembundler.com) | [npm](http://npmjs.org), [browserify](http://github.com/substack/node-browserify) |
| Code organization | `require`                         | [CommonJS](http://commonjs.org) |
| Build tools  | jeweler, rubygems | [browserify](http://github.com/substack/node-browserify) |

By installing Node.js, you have access to a command-line JavaScript runtime, testing, package management, and application building. Running tests from the command-line allows you to more easily use tools like [guard](http://rubydoc.info/gems/guard/frames), run focused unit tests, and easily set up continuous integration.

### Testing

Many JavaScripters run Jasmine in the browser for testing. While it does the job, its syntax is extremely verbose and it breaks the command-line-only workflow. There is a Node.js package for running Jasmine from the command line, but I have found it to be buggy and not as feature rich as a typical command line testing tool. Instead I prefer vows or buster.js. Each supports a simpler "hash" based syntax, as opposed to Jasmine's verbose syntax:

{% highlight javascript %}
// Jasmine

describe('MyClass', function() {
  describe('#myMethod', function() {
    before(function() {
      this.instance = new MyClass('foo');
    });
  
    it('returns true by default', function() {
      expect(this.instance.myMethod()).toBeTruthy();
    });
    it('returns false sometimes', function() {
      expect(this.instance.myMethod(1)).toBeFalsy();
    });
  });
});
{% endhighlight %}


{% highlight javascript %}
// Vows

vows.describe('MyClass').addBatch({
  '#myMethod': {
    topic: new MyClass('foo'),

    'returns true by default': function(instance) {
      assert(instance.myMethod());
    },
    'returns false sometimes': function(instance) {
      refute(instance.myMethod(1));
    }
  }
}).export(module);
{% endhighlight %}

Vows and buster can be used just like `rspec` to run tests from the command line:

    > vows test/my-class-test.js
    ................
    OK >> 22 honored

One advantage that buster has over vows is that it can run its tests both from the command line and from a browser in case you want to run some integration tests in a real browser environment.

For mocks and stubs, you can use the excellent [sinon](http://sinonjs.org) library, which is included by default with buster.js.

#### Integration testing

In addition to unit testing, it's always good run a full integration test. Since every browser has its own quirks, it's best to run integration tests in each browser. I write [cucumber](http://cukes.info) tests using [capybara](http://jnicklas.github.com/capybara/) to automatically drive either a "headless" (in-memory) webkit browser with [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) and/or GUI browsers like Firefox and Chrome with [selenium](http://seleniumhq.org/).

In `features/support/env.rb` you can define which type of browser is used to run the tests by defining custom drivers

{% highlight ruby %}
    require 'selenium-webdriver'

    Capybara.register_driver :selenium_chrome do |app|
      Capybara::Selenium::Driver.new app, :browser => :chrome
    end

    Capybara.register_driver :selenium_firefox do |app|
      Capybara::Selenium::Driver.new app, :browser => :firefox
    end

    if ENV['BROWSER'] == 'chrome'
      Capybara.current_driver = :selenium_chrome
    elsif ENV['BROWSER'] == 'firefox'
      Capybara.current_driver = :selenium_firefox
    else
      require 'capybara-webkit'
      Capybara.default_driver = :webkit
    end
{% endhighlight %}

Now you can choose your browser with an environment variable: `BROWSER=firefox cucumber features`

If you are testing an app apart from a framework like Sinatra or Rails, you can use Rack to serve a static page that includes your built app in a `<script>` tag. For example, you could have an html directory with an `index.html` file in it:

{% highlight html %}
<html>
  <head>
    <title>Test App</title>
    <script type="text/javascript" src="application.js"></script>
  </head>
  <body><div id="app"></div></body>
</html>
{% endhighlight %}

When you're ready to run an integration test, compile your code into `application.js` using browserify:

    > browserify -e lib/main.js -o html/application.js

Then tell cucumber to load your test file as the web app to test:

{% highlight ruby %}
    # features/support/env.rb
    
    require 'rack'
    require 'rack/directory'

    Capybara.app = Rack::Builder.new do
      run Rack::Directory.new(File.expand_path('../../../html/', __FILE__))
    end
{% endhighlight %}

Once cucumber is set up, you can start writing integration tests just as you would with Rails:

    # features/logging_in.feature
    
    Feature: Logging in
    
    Scenario: Successful in-log
      Given I am on the home page
      When I log in as derek
      Then I should see a welcome message


{% highlight ruby %}
    # features/step_definitions/log_in_steps.rb

    Given %r{I am on the home page} do
      visit '/index.html'
    end
    
    When %r{I log in as derek} do
      click '#login'
      fill_in 'username', :with => 'derek'
      fill_in 'password', :with => 'secret'
      click 'input[type=submit]'
    end
    
    Then %r{I should see a welcome message} do
      page.should =~ /Welcome, derek!/
    end
{% endhighlight %}

### Package management

One of the joys of Ruby is its package manager, rubygems. With a simple `gem install` you can add a library to your app. There has been an explosion of JavaScript package managers lately. Each one adds the basic ability to gather all of your libraries and application code, resolve the dependencies, and concatenate them into a single application file. I prefer [browserify](http://github.com/substack/node-browserify) over all the others for two reasons. First, you can use any Node.js package, which opens you up to many more utilities and libraries than other managers. Second, it uses Node.js' CommonJS module system, which is a very simple and elegant module system.

In your project's root, place a `package.json` file that defines the project's dependencies:

{% highlight javascript %}
    {
      "dependencies": {
        "JSONPath": "0.4.2",
        "underscore": "*",
        "jquery": "1.8.1"
      },
      "devDependencies": {
        "browserify": "*",
        "vows": "*"
      }
    }
{% endhighlight %}

Run `npm install` and all of your project's dependencies will be installed into the `node_modules` directory. In your project you can then make use of these packages:

{% highlight javascript %}
    var _ = require('underscore'),
        jsonpath = require('JSONPath'),
        myJson = "...";

    _.each(jsonpath(myJson, '$.books'), function(book) {
      console.log(book);
    });
{% endhighlight %}

If you're looking for packages available for certain tasks, simply run `npm search <whatever>` to find pacakges related to your search terms. Some packages are tagged with "browser" if they are specifically meant for client side apps, so you can include "browser" as one of your search terms to limit your results accordingly. Many of the old standbys, like jquery, backbone, spine, and handlebars are there.

### Code organization

As JavaScript applications get more complex, it becomes prudent to split your code into separate modules, usually placed in separate files. In the Ruby world, this was easily done by `require`-ing each file. Node.js introduced many people (including me) to the CommonJS module system. It's a simple and elegant way to modularize your code and allows you to separate each module into its own file. Browserify allows you to write your code in the CommonJS style and it will roll all of your code up into a single file appropriate for the browser.

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

### Build tools

Browserify will build concatenated JavaScript files when you're ready to deploy your code on a website or as a general-purpose library. Its usage is simple:

    > browserify -e <main_application_startup_code> -o <path_to_built_file>

#### Building a library

If we were building the library in the section above, we could run `browserify -e lib/my-library.js -o build/my-library.js`. Then, any user of your library can use your library with the `require` function:

{% highlight html %}
    <script type="text/javascript" src="jquery.js"></script>
    <script type="text/javascript" src="my-library.js"></script>
    <script type="text/javascript">
      var myLibrary = require('my-library');
      $.ajax('/lib.json', function(data) {
        console.log(myLibrary(data));
      });
    </script>
{% endhighlight %}

You can also save the library user some time with a custom entry point for browsers:

{% highlight javascript %}
    // in /browser.js
    window.MyLibrary = require('my-library');
{% endhighlight %}

Then run `browserify -e browser.js -o build/my-library.js`

And the library user would use it thusly:

{% highlight html %}
    <script type="text/javascript" src="jquery.js"></script>
    <script type="text/javascript" src="my-library.js"></script>
    <script type="text/javascript">
      $.ajax('/lib.json', function(data) {
        console.log(MyLibrary(data));
      });
    </script>
{% endhighlight %}

#### Building a web app

A spine app might look something like:

{% highlight javascript %}
    // in app/main.js
    
    var $ = require('jquery'),
        Spine = require('spine');

    Spine.$ = $;

    var MainController = require('./controllers/main-controller');

    var ApplicationController = Spine.Controller.sub({
      init: function() {
        var main = new MainController();
        this.routes({
          '/': function() { main.active(); }
        });
      }
    });

    Spine.Route.setup({ history: true });
{% endhighlight %}

It would be built with `browserify -e app/main.js -o build/application.js` and the application.js added to your website with a `<script>` tag.

You can extend browserify with plugins like [templatify](https://github.com/mklabs/templatify#readme), which precompiles HTML/Handlebar templates into your app.

Together, npm packages, command-line testing and build tools, and modular code organization help you quickly build non-trivial JavaScript libraries and applications just as easily as it was in Ruby land. I've developed several in-production projects using this workflow, such as our [CM1](http://github.com/dkastner/CM1.js) JavaScript client library, our flight search [browser plugin](http://github.com/brighterplanet/careplane), and [hootroot.com](http://github.com/brighterplanet/hootroot1).

<!-- more end -->
