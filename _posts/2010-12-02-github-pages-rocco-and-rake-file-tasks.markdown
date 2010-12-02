---
title: Github Pages, Rocco, and Rake File Tasks
author: Derek
layout: post
categories: technology
---

Recently, we spiffed up some of our emitters with enhanced documentation using [Rocco](http://rubygems.org/gems/rocco), a Ruby port of Docco.  We combined this with github's ability to set up [static html pages for a repo](http://pages.github.com/).  By setting up a branch called gh-pages, Github will serve any html files in that branch.  We use this feature to display Rocco-generated documentation of our carbon models (check out the [flight emitter](http://brighterplanet.github.com/flight/carbon_model.html) for an example).

This was great, but we were missing a way to automate the process by which Rocco will generate its documentation from the code in the master branch and place them in the gh-pages branch.  Ryan Tomayko came to the rescue and [wrote a rake task](http://github.com/rtomayko/rocco/blob/cffe49a813bbc083c695997c5d2a7da7f3cf99a1/Rakefile) that creates a docs directory within the project and initializes a new git repository within the directory, which points to the project's gh-pages branch.  When documentation is generated, it is copied to the docs folder and pushed to gh-pages.

What intrigued me about the rake task was its use of file tasks.  It's a feature of rake I had never noticed before, but it's pretty slick.  A file task says, "if the specified path does not exist, execute the following code."  Since many unix tools use files for configuration, this feature plays well with many utilities, such as git, your favorite editor, etc. 

For example, you could define a rake task that will create a .rvmrc for your project using your current [RVM](http://rvm.beginrescueend.com/)-installed ruby:

    # Rakefile
    
    file '.rvmrc' do |f|
      File.open(f.name, 'w') do |rvmrc|
        rvmrc.puts "rvm #{ENV['rvm_ruby_string']}"
      end
    end
{: ruby}

When you run `rake .rvmrc`, your .rvmrc will be generated.  Try it out!

There is all kinds of magic you can work with a file task.  A novel way in which Ryan's Rocco tasks use file tasks is when deciding whether to create a git remote based on whether there is a file referencing the remote in the .git configuration directory:

    # Rakefile
    
    file '.git/refs/heads/gh-pages' => 'docs/' do |f|
      `cd docs && git branch gh-pages --track origin/gh-pages`
    end
{: ruby}

Happy raking!
