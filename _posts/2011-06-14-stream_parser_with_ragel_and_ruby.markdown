---
title: Stream parser with Ragel and Ruby
author: Seamus
layout: post
categories: technology
---

Say you have a file like

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer a
    tristique lectus. Vestibulum ante ipsum primis in faucibus orci luctus et
    aliquet laoreet, iacSTARTFOOThere are lots of great ideas here.ENDFOOulis
    a lorem. Integer interdum, dolor aliquam accumsan eleifend, nisl tortor
    mollis ipsum, et semper arcu mi nec felis. Nunc scelerisque cursus dolor
    eu tristique. Mauris porta pulvinar dolor. Integer egestas lacinia leo, ut
    mollis sapien fermentum non. Maecenas ultricies nibh at justo ornare eu
    ullamcorper justo aliquet. Cras id augue eget nunc auctor mattis vitae
    quis massa. STARTFOOYou just have to look closelyENDFOOMauris suscipit
    justo in erat scelerisque imperdiet.

You want to pull out

    There are lots of great ideas here.
    You just have to look closely

**You can use Ragel for that.** Because of how Ragel works, you can even make a stream parser that reads in one chunk at a time instead of the whole file at once, allowing you to keep memory usage constant. As I show in my [ragel_ruby_examples](https://github.com/seamusabshere/ruby_ragel_examples) tests, you could even read the stream 1 byte at a time.

Here's the Ragel part:

{% highlight ragel %}
  machine simple_tokenizer;

  action Keep {
    # Since we're not in ragel's scanner mode, we'll define our own "ts" variable
    ts = p
  }
  action Emit {
    emit data[ts...p].pack('c*')
    ts = nil
    prefixing = false
  }

  foo = 'STARTFOO' any+ >Keep %Emit :>> 'ENDFOO';

  main := ( any+ | foo )*;
{% endhighlight %}

...and here's the Ruby reading/buffering mechanism...

{% highlight ruby %}
  def perform
    pe = :ignored
    eof = :ignored
    %% write init;
    # % (this fixes syntax highlighting)
    prefix = []
    ts = nil
    prefixing = false
    File.open(path) do |f|
      while chunk = f.read(ENV['CHUNK_SIZE'].to_i)
        data = prefix + chunk.unpack('c*')
        p = 0
        pe = data.length
        %% write exec;
        # % (this fixes syntax highlighting)
        if ts
          prefix = data[ts..-1]
          ts = 0
          prefixing = true
        elsif prefixing
          prefix = data
          prefixing = false
        else
          prefix = []
        end
      end
    end
  end
{% endhighlight %}

Again, you can see more at [ragel_ruby_examples](https://github.com/seamusabshere/ruby_ragel_examples), specifically [simple_tokenizer.rl](https://github.com/seamusabshere/ruby_ragel_examples/blob/master/simple_tokenizer.rl).

Final note: I realize this isn't precisely a parser or even a tokenizer... but these sorts of examples are what I would have wanted when I was getting started with Ragel and Ruby. What's more, hopefully the Ragel community will chime in and improve the examples.
