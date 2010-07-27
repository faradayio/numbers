---
title: Sharing views across Rails 3 apps
author: Andy
layout: post
categories: rails
---

Here at Brighter Planet we run several production Rails 3 apps, including the [emission estimates service](http://carbon.brighterplanet.com), the [climate data service](http://data.brighterplanet.com), and our [keyserver](http://keys.brighterplanet.com). As the person reponsible for much of our recent front-end work, I wasn't really looking forward to maintaining a half-dozen different versions of what is mostly the same layout. I wanted to [DRY](http://www.c2.com/cgi/wiki?DontRepeatYourself) the situation up. What I really wanted was to put all the shared stuff into a gem that I could require from all of our apps that would just sort of insinuate itself into all the right places.

Luckily Rails 3 makes this possible, after a fashion. The key trick is giving your plugin a Railtie, which isn't documented very well yet--this [gist from Jose Valim](https://gist.github.com/e139fa787aa882c0aa9c) is the best I could find.

To get started just add a file in `lib/gemname/` called `railtie.rb` and require it from the main `gemname.rb` file:

{% highlight ruby %}
module BrighterPlanetLayout
  class Railtie < Rails::Railtie
  end
end
{% endhighlight %}

Because it inherits from Rails::Railtie, you don't have to "declare" the Railtie--Rails automatically keeps track of it and calls the right parts when they're needed.

The easy part is telling Rails to add your gem's view path to the app's view path:

{% highlight ruby %}
module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views.push BrighterPlanetLayout.view_path
    end
  end
end
{% endhighlight %}

Telling ApplicationController to use the layout in your gem's view path as the default is a little tricker--you have to use a `to_prepare` block:

{% highlight ruby %}
module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    # ...
    config.to_prepare do
      ApplicationController.layout 'brighter_planet'
    end
  end
end
{% endhighlight %}

It turns out the hardest part is hooking Rails up to your gem's static asset files--stylesheets, images, fonts, etc. For that we add another instance of `ActionDispatch::Static` to the Rack middleware stack:

{% highlight ruby %}
module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    config.app_middleware.use '::ActionDispatch::Static', BrighterPlanetLayout.public_path
    # ...
  end
end
{% endhighlight %}

This is a fine solution in the development environment, but it's too slow for production--your webserver has to fire up Rails just to push an image binary, for example. So in production we just copy static files to the app's `public` dir:

{% highlight ruby %}
module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    if BrighterPlanetLayout.serve_static_files_using_rack? # "if in development environment"
      config.app_middleware.use '::ActionDispatch::Static', BrighterPlanetLayout.public_path
    end
    initializer 'brighter_planet_layout.copy_static_files_to_web_server_document_root' do
      if BrighterPlanetLayout.copy_static_files? # "if in production"
        BrighterPlanetLayout.copy_static_files_to_web_server_document_root
      end
    end
    # ...
  end
end
{% endhighlight %}

And that's it. Check out [the gem source](http://github.com/brighterplanet/brighter_planet_layout) for details on the folder structure and for additional tricks like loading shared helpers. Next time: how to use this shared layout with Jekyll.
