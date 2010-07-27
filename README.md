# numbers

This repository drives Brighter Planet's blog, [Safety in Numbers](http://numbers.brighterplanet.com) via [Jekyll](http://github.com/mojombo/jekyll) on [GitHub Pages](http://pages.github.com).

## To start blogging

    $ git clone http://github.com/brighterplanet/numbers.git

## To add a post

Always start out with

    $ git pull

You're going to create a file in the _posts directory named like:

    year-month-day-here-is-my-title.extension
    
So, for example:

    $ mate _posts/2010-07-23-new-blog.md
    
The extension says what markup language you want to use. "md" is for Markdown, which is my fave, but you can use "textile," "html," etc.

At the top of your file you'll need a metadata section that looks like this:

    ---
    title: Relaunching the blog
    author: Andy
    layout: post
    categories: meta
    ---

(The three dashes at the top and bottom are important.)

Author is your first name, layout should always stay "post", and categories (if you want any) can either be a single category or a list of categories in brackets (e.g. [rails, middleware]). If you use categories, make sure they've been created (see below).

Whatever goes below this metadata section is your post.

## To preview your post/changes

    $ jekyll --server

Then go to [localhost:4000](http://localhost:4000)

## To push your post/changes

    $ git add _posts/2010-01-01-my-awesome-post.md
    $ git commit -m "First draft of 'My Awesome Post'"
    $ git push
    
Then go to [numbers.brighterplanet.com](http://numbers.brighterplanet.com)

## To add a category/tag

Open _config.yml and add your tag to the list:

    cats: [rails, middleware, meta, awesometag]
    
Copy rails.html to awesometag.html, change the title at the top and the header on line 5.

## When in doubt

Just look at older posts for guidance
