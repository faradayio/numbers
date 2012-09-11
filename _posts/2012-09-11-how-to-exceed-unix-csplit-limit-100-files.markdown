---
title: How to exceed UNIX csplit limit of 100 files
author: Seamus
layout: post
categories: technology techresearch
---

[`csplit`](http://en.wikipedia.org/wiki/Csplit) and [`split`](http://en.wikipedia.org/wiki/Split_%28Unix%29) are useful for splitting up files for batch processing:

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

To get one file for every `TourismEntity`, split on the string `"<TourismEntity"`...

{% highlight console %}
$ split -p '<TourismEntity' transmission_file.xml
$ csplit -s -k transmission_file.xml '/<TourismEntity/' '{100}' # but you can't go more than 100
{% endhighlight %}

but `split` and `csplit` both have a 100-file limit. If you have more records than that, use [`gawk`](http://www.gnu.org/software/gawk/):

{% highlight console %}
$ gawk 'BEGIN { RS="<TourismEntity"; ORS="" } { print $0 > ("part" t++ ".txt") }' transmission_file.xml
{% endhighlight %}

(thanks to [this question on StackOverflow](http://stackoverflow.com/questions/290503/how-do-you-split-a-file-base-on-a-token))

<!-- more start -->

### Some post-processing required

Since `gawk` (the free and more powerful version of `awk`) is using `"<TourismEntity"` as the `RS` (record separator), you have to be a little careful with the results:

{% highlight console %}
$ ls
part0.txt part1.txt part2.txt part3.txt
$ cat part0.txt 
<TransmissionFile>
$ cat part1.txt 
>
    <State>New York</State>
    <Saying>I♥NY</Saying>
  </TourismEntity>
$ cat  part2.txt 
>
    <State>Virginia</State>
    <Saying>Is For Lovers</Saying>
  </TourismEntity>
$ cat part3.txt 
>
    <State>Wisconsin</State>
    <Saying>America's Dairyland</Saying>
  </TourismEntity>
</TransmissionFile>
{% endhighlight %}

Here's what you have to do:

1. Ignore `part0.txt` (it's what was before the first `TourismEntity`)
2. Prepend the `RS` (`"<TourismEntity"`) to the beginning of every XML snippet
3. Crop every file after `"</TourismEntity>"`

<!-- more end -->
