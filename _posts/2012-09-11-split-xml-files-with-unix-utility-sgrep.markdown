---
title: Split XML files with `sgrep`, a classic UNIX utility from 1995
author: Seamus
layout: post
categories: technology techresearch
---

[`sgrep`](http://www.cs.helsinki.fi/u/jjaakkol/sgrepman.html) is better than [`split`](http://en.wikipedia.org/wiki/Split_%28Unix%29) or [`csplit`](http://en.wikipedia.org/wiki/Csplit) for breaking up XML files by element &ndash; you can even use it to create a constant-memory streaming "parser."

{% highlight console %}
$ sgrep -o "XXXSTART%rSTOPXXX" '"<TourismEntity" .. "</TourismEntity"' transmission_file.xml
XXXSTART<TourismEntity>
    <State>New York</State>
    <Saying>I♥NY</Saying>
  </TourismEntitySTOPXXXXXXSTART<TourismEntity>
    <State>Virginia</State>
    <Saying>Is For Lovers</Saying>
  </TourismEntitySTOPXXXXXXSTART<TourismEntity>
    <State>Wisconsin</State>
    <Saying>America's Dairyland</Saying>
  </TourismEntitySTOPXXX
{% endhighlight %}

(see below for why that output is useful)

<!-- more start -->

### tl;dr

`sgrep` and a simple Ruby program (given below) let you stream XML elements into an `#emit` method that can do whatever you want. What's more, the memory usage is constant (and small); memory usage doesn't grow like if you parse the entire XML document into memory like with [nokogiri](http://nokogiri.org/).

### Using sgrep to split XML

Combine `sgrep` with, for example, a Ruby program:

{% highlight ruby %}
#!/usr/bin/env ruby

# your target element here
ELEMENT_START = '<TourismEntity'
ELEMENT_STOP = '</TourismEntity'

# your emit code here - in this case I'm just writing it to a separate file named tourism_entity-NUM.txt
def emit(tourism_entity)
  $tourism_entity_count ||= 0
  $tourism_entity_count += 1
  File.open("tourism_entity-#{$tourism_entity_count}.txt", 'w') { |f| f.write tourism_entity }
end

SGREP_BIN = %w{ sgrep sgrep2 }.detect { |bin| `which #{bin}`; $?.success? }
MAGIC_START = 'XXXSTART'
MAGIC_STOP = 'STOPXXX'

leftover = ''
IO.popen([ SGREP_BIN, '-n', '-o', "#{MAGIC_START}%r#{MAGIC_STOP}", %{"#{ELEMENT_START}" .. "#{ELEMENT_STOP}"}, ARGV[0] ]) do |io|
  while additional = io.read(65536)
    buffer = leftover + additional
    while (start = buffer.index(MAGIC_START)) and (stop = buffer.index(MAGIC_STOP))
      element_body = buffer[(start+MAGIC_START.length)...stop] + '>'
      # what "emit" does is up to you
      emit element_body
      buffer = buffer[(stop+MAGIC_STOP.length)..-1]
    end
    leftover = buffer
  end
end
{% endhighlight %}

So let's go back to the example, `transmission_file.xml`:

{% highlight xml %}
<TransmissionFile>
  <TourismEntity>
    <State>New York</State>
    <Saying>I♥NY</Saying>
  </TourismEntity>
  <TourismEntity>
    <State>Virginia</State>
    <Saying>Is For Lovers</Saying>
  </TourismEntity>
  <TourismEntity>
    <State>Wisconsin</State>
    <Saying>America's Dairyland</Saying>
  </TourismEntity>
</TransmissionFile>
{% endhighlight %}

You will get:

{% highlight console %}
$ ruby emit_tourism_entity.rb transmission_file.xml 
$ tail +1 tourism_entity-*
==> tourism_entity-1.txt <==
  <TourismEntity>
    <State>New York</State>
    <Saying>I♥NY</Saying>
  </TourismEntity>
==> tourism_entity-2.txt <==
  <TourismEntity>
    <State>Virginia</State>
    <Saying>Is For Lovers</Saying>
  </TourismEntity>
==> tourism_entity-3.txt <==
  <TourismEntity>
    <State>Wisconsin</State>
    <Saying>America's Dairyland</Saying>
  </TourismEntity>
{% endhighlight %}

What's happening is:

1. Ruby spawns `sgrep` using a pipe
2. `sgrep` spits out a stream of element bodies separated by "XXXSTART" and "STOPXXX" into the pipe
3. Ruby reads from the pipe and watches for element bodies separated by the aforementioned magic tokens
4. When Ruby sees a whole element body, it runs `#emit`

### Why are you so amazed by this program from 1995

Because just look at that beautiful syntax:

{% highlight console %}
$ sgrep '"{" .. "}"' eval.c
{% endhighlight %}

And because memory usage is really low, and it's really fast.

### I have less than 100 elements and just want to split up the file

Both of these will break up the XML file into separate files without the need for a Ruby wrapper:

{% highlight console %}
$ split -p '<TourismEntity' transmission_file.xml
$ csplit -s -k transmission_file.xml '/<TourismEntity/' '{100}'
{% endhighlight %}

But there are little problems, like you max out at 100 separate files (i.e. elements), and other things.

<!-- more end -->
