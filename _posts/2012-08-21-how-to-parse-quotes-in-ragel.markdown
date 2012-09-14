---
title: How to parse quotes in Ragel (and Ruby)
author: Seamus
layout: post
categories: technology techresearch
---

The key to parsing quotes in Ragel is <tt>([^'\\]&nbsp;|&nbsp;/\\./)*</tt> as found in the [`rlscan` example](http://www.complang.org/ragel/examples/rlscan.rl). Think of it as <tt>(&nbsp;not_quote_or_escape&nbsp;|&nbsp;escaped_something&nbsp;)*</tt>.

<!-- more start -->

### Making it work with single and double quotes

Here's the heart of [a working example](/images/2012-08-21-how-to-parse-quotes-in-ragel/not_scanner.rl.txt) that covers both single and double quotes:

{% highlight ragel %}
%%{
  machine not_scanner;

  action Start {
    s = p
  }
  action Stop {
    quoted_text = data[s...p].pack('c*')
    # do something with the quoted text!
  }

  squote = "'";
  dquote = '"';
  not_squote_or_escape = [^'\\];
  not_dquote_or_escape = [^"\\];
  escaped_something = /\\./;
  ss = space* squote ( not_squote_or_escape | escaped_something )* >Start %Stop squote;
  dd = space* dquote ( not_dquote_or_escape | escaped_something )* >Start %Stop dquote;

  main := (ss | dd)*;
}%%
{% endhighlight %}

### Why does it work?

Use this example string:

<p style="font-size: large">"a\"bc"</p>

Follow it on the graph: (notice the symmetry... the "top" processes double quotes and the "bottom" processes single quotes)

<p class="wide">
  <a href="/images/2012-08-21-how-to-parse-quotes-in-ragel/not_scanner.svg" title="graph of the state machine">
    <img src="/images/2012-08-21-how-to-parse-quotes-in-ragel/not_scanner.png" alt="thumbnail of the graph of the state machine" />
  </a>
</p>

... tl;dr ...

       "      a     \     "     b      c      "
    ➇  →  ➁  →  ➂  →  ➃  →  ➂  →  ➂  →  ➂  →  ➇
                         BAM!

State ➃ is eating the escaped double quote and therefore preventing the machine from stopping&mdash;that's the key!

### You can also do it with a scanner

Here's what you would do in [a scanner](/images/2012-08-21-how-to-parse-quotes-in-ragel/scanner.rl.txt):

{% highlight ragel %}
%%{
  machine scanner;

  action GotOne {
    quoted_text = data[(ts+1)...(te-1)].pack('c*')
    # do something with quoted text!
  }

  squote = "'";
  dquote = '"';
  not_squote_or_escape = [^'\\];
  not_dquote_or_escape = [^"\\];
  escaped_something = /\\./;

  main := |*
    squote ( not_squote_or_escape | escaped_something )* squote => GotOne;
    dquote ( not_dquote_or_escape | escaped_something )* dquote => GotOne;
    any;
  *|;
}%%
{% endhighlight %}

<!-- more end -->
