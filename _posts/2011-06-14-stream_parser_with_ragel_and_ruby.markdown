---
title: Stream parser with Ragel and Ruby
author: Seamus
layout: post
categories: technology
---

You can use Ragel to make simple stream parsers in Ruby. By "stream parser," I mean one that reads in files a chunk at a time instead of all at once---thereby keeping memory use constant.

<!-- more start -->

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

As I show in my [ragel_ruby_examples](https://github.com/seamusabshere/ruby_ragel_examples) tests, you could even read the stream 1 byte at a time.

Here's the Ragel part:

{% highlight ragel %}
  machine simple_tokenizer;
  action MyTs {
    my_ts = p
  }
  action MyTe {
    my_te = p
  }
  action Emit {
    emit data[my_ts...my_te].pack('c*')
    my_ts = nil
    my_te = nil    
  }
  foo = 'STARTFOO' any+ >MyTs :>> 'ENDFOO' >MyTe %Emit;
  main := ( foo | any+ )*;
{% endhighlight %}

...and here's the Ruby reading/buffering mechanism...

{% highlight ruby %}
  CHUNK_SIZE = 1_000_000 # bytes (instead of reading in the whole file all at once)
  # Note: use with simple_tokenizer
  def perform
    pe = :ignored
    eof = :ignored
    %% write init;
    # % (this fixes syntax highlighting)
    leftover = []
    my_ts = nil
    my_te = nil
    File.open(path) do |f|
      while chunk = f.read(CHUNK_SIZE)
        data = leftover + chunk.unpack('c*')
        p = 0
        pe = data.length
        %% write exec;
        # % (this fixes syntax highlighting)
        if my_ts
          leftover = data[my_ts..-1]
          my_te = my_te - my_ts if my_te
          my_ts = 0
        else
          leftover = []
        end
      end
    end
  end
{% endhighlight %}

Alternatively you could use Ragel's **scanner** functionality:

{% highlight ragel %}
  machine simple_scanner;
  action Emit {
    emit data[(ts+8)..(te-7)].pack('c*')
  }
  foo = 'STARTFOO' any+ :>> 'ENDFOO';
  main := |*
    foo => Emit;
    any;
  *|;
{% endhighlight %}

Which requires buffering code like:

{% highlight ruby %}
  CHUNK_SIZE = 1_000_000 # bytes (instead of reading in the whole file all at once)
  # Note: use with simple_scanner
  def perform
    pe = :ignored
    eof = :ignored
    %% write init;
    # % (this fixes syntax highlighting)
    leftover = []
    File.open(path) do |f|
      while chunk = f.read(CHUNK_SIZE)
        data = leftover + chunk.unpack('c*')
        p ||= 0
        pe = data.length
        %% write exec;
        # % (this fixes syntax highlighting)
        if ts
          leftover = data[ts..pe]
          p = p - ts
          ts = 0
        else
          leftover = []
          p = 0
        end
      end
    end
  end
{% endhighlight %}

Again, you can see more at [ragel_ruby_examples](https://github.com/seamusabshere/ruby_ragel_examples), specifically [simple_tokenizer.rl](https://github.com/seamusabshere/ruby_ragel_examples/blob/master/lib/simple_scanner.rl).

Final note: I realize this isn't precisely a parser or even a tokenizer... but these sorts of examples are what I would have wanted when I was getting started with Ragel and Ruby. What's more, hopefully the Ragel community will chime in and improve the examples.

<!-- more end -->
