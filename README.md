# numbers

This repository drives Brighter Planet's blog, [Safety in Numbers](http://numbers.brighterplanet.com) via [Jekyll](http://github.com/mojombo/jekyll) on [GitHub Pages](http://pages.github.com).

## To start blogging

    $ git clone http://github.com/brighterplanet/numbers.git

## To add a post

Always start out with

    $ git pull

Then stub out the post

    $ rake post["My fancy title",Andy]
    
Now open the new file that was created. At the top, you'll need a metadata section that looks like this:

    ---
    title: My fancy title
    author: Andy
    layout: post
    categories: technology
    ---

Author is your first name (first letter capped), layout should always stay "post", and categories (if you want any) can either be a single category or a list of categories in brackets. You can use `company`, `technology`, and `science`.

Whatever goes below this metadata section is your post.

## To specify what goes in "Read More"

Wrap the part that gets hidden with these HTML comments: (verbatim!)

    ---
    title: some post
    layout: post
    ---

    Some intro, this will be visible on the index page.

    <!-- more start -->

    More content, this will not be visible on the index page.

    <!-- more end -->

The "more end" comment should go at the bottom of the document, below everything else.

See 2011-01-13-announcing-our-new-parcel-shipment-model.markdown for a good example and make sure that you always put BOTH comments, "more start" and then "more end".

The process is taken from http://kaspa.rs/2011/04/jekyll-hacks-html-excerpts/

## To preview your post/changes

    $ jekyll --server

Then go to [localhost:4000](http://localhost:4000)

## To push your post/changes

    $ git add _posts/2010-01-01-my-awesome-post.md
    $ git commit -m "First draft of 'My Awesome Post'"
    $ git push
    
Then go to [numbers.brighterplanet.com](http://numbers.brighterplanet.com)

## When in doubt

Just look at older posts for guidance
