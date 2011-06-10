---
title: A Pattern for JavaScript Events
author: derek
layout: post
categories: technology
---

While working on [Hootroot](http://hootroot.com) and [Careplane](http://careplane.org), I found myself getting frustrated with the way I was having handling events. Over time, however, I stopped fighting the language and learned a pattern that I believe is easiest to test and read.

I'll work with a simple example to show you my thought process.

Initially, I started handling my events with standard closures:

{% highlight javascript %}
//Rocket.js

Rocket = function(location) {
  this.location = location;
};

Rocket.prototype.ignite = function() { /* ... */ };
Rocket.prototype.scrub = function() { /* ... */ };

Rocket.prototype.launch = function() {
  var rocket = this;
  $.ajax('/launch_code', {
    data: { location: this.location },
    success: function(data) {
      if(rocket.isReady()) {
        alert('Launching from ' + rocket.location);
        rocket.ignite(data.launchCode);
      } else {
        alert('Not ready to launch!');
      }
    },
    error: function() {
      alert('Failed to get launch code for ' + rocket.location);
      rocket.scrub();
    }
  });
};

//RocketSpec.js

describe('Rocket', function() {
  describe('#launch', function() {
    var rocket;
    beforeEach(function() {
      rocket = new Rocket('Cape Canaveral, FL');
      fakeAjax({urls: {'/launch_code': {successData: '{ "launchCode": 12345 }'}}})
      spyOn(rocket, 'ignite');
      spyOn(rocket, 'scrub');
    });

    it('ignites if ready', function() {
      rocket.isReady = function() { return true; };
      rocket.launch();
      expect(rocket.ignite).toHaveBeenCalled();
    });
    it('waits if not ready', function() {
      rocket.isReady = function() { return false; };
      rocket.launch();
      expect(rocket.ignite).not.toHaveBeenCalled();
    });
    it('scrubs if a bad launch code is given', function() {
      fakeAjax({urls: {'/launch_code': { errorMessage: '{ "error": "too bad" }'}}})
      rocket.launch();
      expect(rocket.scrub).toHaveBeenCalled();
    });
  });
});
{% endhighlight %}

Because of the way [this](http://www.digital-web.com/articles/scope_in_javascript/) works in JavaScript, I had to assign the `this` that referred to the current instance of Rocket to a temporary variable that is referenced in the event handlers. This seemed kludgy to me, and I soon discovered the $.proxy() method that jQuery (and other frameworks similarly) provide:

{% highlight javascript %}
//Rocket.js

Rocket = function(location) {
  this.location = location;
};

Rocket.prototype.ignite = function() { /* ... */ };
Rocket.prototype.scrub = function() { /* ... */ };

Rocket.prototype.launch = function() {
  $.ajax('/launch_code', {
    data: { location: this.location },
    success: $.proxy(function(data) {
      if(this.isReady()) {
        alert('Launching from ' + this.location);
        this.ignite(data.launchCode)
      } else {
        alert('Not ready to launch!');
      }
    }, this),
    error: $.proxy(function() {
      alert('Failed to get launch code for ' + this.location);
      this.scrub();
    }, this)
  });
};

//RocketSpec.js

describe('Rocket', function() {
  describe('#launch', function() {
    var rocket;
    beforeEach(function() {
      rocket = new Rocket('Cape Canaveral, FL');
      fakeAjax({urls: {'/launch_code': {successData: '{ "launchCode": 12345 }'}}})
      spyOn(rocket, 'ignite');
      spyOn(rocket, 'scrub');
    });

    it('ignites if ready', function() {
      rocket.isReady = function() { return true; };
      rocket.launch();
      expect(rocket.ignite).toHaveBeenCalled();
    });
    it('waits if not ready', function() {
      rocket.isReady = function() { return false; };
      rocket.launch();
      expect(rocket.ignite).not.toHaveBeenCalled();
    });
    it('scrubs if a bad launch code is given', function() {
      fakeAjax({urls: {'/launch_code': { errorMessage: '{ "error": "too bad" }'}}})
      rocket.launch();
      expect(rocket.scrub).toHaveBeenCalled();
    });
  });
});
{% endhighlight %}

The problem now is there are all sorts of functions hanging around within `Rocket#launch()` that are a bit difficult to test in a straightforward manner. Solution: create some functions on Rocket that act as event handlers.

{% highlight javascript %}
// Rocket.js

Rocket = function() {
  this.location = 'Cape Canaveral, FL';
};

Rocket.prototype.igniteWhenReady = function(data) {
  if(this.isReady()) {
    alert('Launching from ' + this.location);
    this.ignite(data.launchCode);
  } else {
    alert('Not ready to launch!');
  }
};

Rocket.prototype.invalidLaunchCode = function() {
  alert('Failed to get launch code for ' + this.location);
  this.scrub();
};

Rocket.prototype.launch = function() {
  $.ajax('/launch_code', {
    data: { location: this.location },
    success: $.proxy(this.igniteWhenReady, this),
    error: $.proxy(this.invalidLaunchCode, this)
  });
};

//RocketSpec.js

describe('Rocket', function() {
  var rocket;
  beforeEach(function() {
    rocket = new Rocket('Cape Canaveral, FL');
    spyOn(rocket, 'ignite');
    spyOn(rocket, 'scrub');
  });

  describe('#launch', function() {
    // we don't need to test launch() because we'd really just be testing $.ajax
  });

  describe('#igniteWhenReady', function() {
    it('ignites if ready', function() {
      rocket.isReady = function() { return true; };
      rocket.igniteWhenReady({ launchCode: 12345 });
      expect(rocket.ignite).toHaveBeenCalled();
    });
    it('does not ignite if not ready', function() {
      rocket.isReady = function() { return false; };
      rocket.igniteWhenReady();
      expect(rocket.ignite).not.toHaveBeenCalled();
    });
  });
  describe('#invalidLaunchCode', function() {
    it('scrubs if a bad launch code is given', function() {
      rocket.invalidLaunchCode();
      expect(rocket.scrub).toHaveBeenCalled();
    });
  });
});
{% endhighlight %}

This is much cleaner and easier to test, but those lingering `$.proxy()` calls were bugging me. They also made debugging a bit more tedious when having to step through the calls to $.proxy.

My solution: stop fighting with `this` and create my own event proxy pattern. Testing is now much cleaner.

{% highlight javascript %}
//Rocket.js

Rocket = function(location) {
  this.location = location;
};

Rocket.prototype.ignite = function() { /* ... */ };
Rocket.prototype.scrub = function() { /* ... */ };

Rocket.events = {
  igniteWhenReady: function(rocket) {
    return function(data)
      if(rocket.isReady()) {
        alert('Launching from ' + rocket.location);
        rocket.ignite(data.launchCode);
      } else {
        alert('Not ready to launch!');
      }
    };
  },

  invalidLaunchCode: function(rocket) {
    return function() {
      alert('Failed to get launch code for ' + rocket.location);
      rocket.scrub();
    };
  }
};

Rocket.prototype.launch = function() {
  $.ajax('/launch_code', {
    data: { location: this.location },
    success: Rocket.events.igniteWhenReady(this),
    error: Rocket.events.invalidLaunchCode(this)
  });
};

//RocketSpec.js

describe('Rocket', function() {
  var rocket, igniteWhenReady, invalidLaunchCode;
  beforeEach(function() {
    rocket = new Rocket('Cape Canaveral, FL');
    spyOn(rocket, 'ignite');
    spyOn(rocket, 'scrub');
    igniteWhenReady = Rocket.events.igniteWhenReady(rocket);
    invalidLaunchCode = Rocket.events.invalidLaunchCode(rocket);
  });

  describe('.events', function() {
    describe('.igniteWhenReady', function() {
      it('ignites if ready', function() {
        rocket.isReady = function() { return true; };
        igniteWhenReady({ launchCode: 12345 });
        expect(rocket.ignite).toHaveBeenCalled();
      });
      it('does not ignite if not ready', function() {
        rocket.isReady = function() { return false; };
        igniteWhenReady();
        expect(rocket.ignite).not.toHaveBeenCalled();
      });
    });
    describe('.invalidLaunchCode', function() {
      it('scrubs if a bad launch code is given', function() {
        invalidLaunchCode();
        expect(rocket.scrub).toHaveBeenCalled();
      });
    });
  });
});
{% endhighlight %}

The result is much more readable code, easier debugging (when absolutely necessary), and simpler testing without all those nested closures and AJAX stubs. As an added bonus, you get to keep the `this` in your event handlers that refers to the event itself.

This experience has led me to believe that a lot of the problems CoffeeScript tries to solve (like [function binding](http://jashkenas.github.com/coffee-script/#fat_arrow)) can really just be solved using good, simple JavaScript coding practices. I'm happy to hear from anyone who has a better pattern or has had similar experiences.
