---
title: Use Amazon SQS to get emission estimates
author: Seamus
layout: post
categories: [middleware]
---

You can get emission estimates by queueing up messages on [Amazon SQS](http://aws.amazon.com/sqs):

{% highlight console %}
$ curl -v https://queue.amazonaws.com/121562143717/cm1_production_incoming -X POST --data "Action=SendMessage&Version=2009-02-01&MessageBody=emitter%3Dautomobile%26make%3DNissan%26guid%3DMyFavoriteCar%26key%3D86f7e437faa5a7fce15d1ddcb9eaeaea377667b8"
* About to connect() to queue.amazonaws.com port 443 (#0)
*   Trying 72.21.211.87... connected
* Connected to queue.amazonaws.com (72.21.211.87) port 443 (#0)
  # eliding some standard server messages for brevity . . .
> POST /121562143717/cm1_production_incoming HTTP/1.1
> User-Agent: curl/7.20.0 (i386-apple-darwin9.8.0) libcurl/7.20.0 OpenSSL/0.9.8m zlib/1.2.3 libidn/1.16
> Host: queue.amazonaws.com
> Accept: */*
> Content-Length: 158
> Content-Type: application/x-www-form-urlencoded
> 
< HTTP/1.1 200 OK
< Content-Type: text/xml
< Transfer-Encoding: chunked
< Date: Wed, 11 Aug 2010 08:20:56 GMT
< Server: AWS Simple Queue Service
< 
<?xml version="1.0"?>
* Connection #0 to host queue.amazonaws.com left intact
* Closing connection #0
* SSLv3, TLS alert, Client hello (1):
<SendMessageResponse xmlns="http://queue.amazonaws.com/doc/2009-02-01/"><SendMessageResult><MD5OfMessageBody>fb29551a9e1c36dcf1b8ba624695210a</MD5OfMessageBody><MessageId>5d48a63b-5416-4d35-8bc5-65ace74f4d42</MessageId></SendMessageResult><ResponseMetadata><RequestId>a3e0d71a-9e47-493b-a92c-29b37393e899</RequestId></ResponseMetadata></SendMessageResponse>
{% endhighlight %}

You need to use this SQS queue: (but you don't need an SQS account, it's just a standard HTTP POST)

    https://queue.amazonaws.com/121562143717/cm1_production_incoming

As you can see, the MessageBody is the url-encoded form of a querystring:

    emitter=automobile&make=Nissan&guid=MyFavoriteCar&key=86f7e437faa5a7fce15d1ddcb9eaeaea377667b8

### Wait a minute, isn't that an empty response body?

Correct. This is an asynchronous way of doing things. The [result in JSON format](http://storage.carbon.brighterplanet.com/745c4bcda8234186178e8430ae55f38913a5f042) will appear as soon as it is calculated (usually in a few seconds).

If you need an answer in realtime, then you should skip SQS and hit [mostly the same querystring](http://carbon.brighterplanet.com/automobiles.json?make=Nissan&guid=MyFavoriteCar&key=86f7e437faa5a7fce15d1ddcb9eaeaea377667b8).

### Why use SQS?

Depending on your environment, you may already have an excellent SQS client library. You'll have the high availability of Amazon web services combined with competitive Brighter Planet pricing for asynchronous (rather than realtime) emission estimates.

Depending on your application, set-it-and-forget-it may be a natural fit. We'll store the result for you in JSON format at an effectively randomized URL, which is perfect for AJAX calls that display results in a browser. In general, if you can queue up the emission estimate now and count on a JSON-enabled client to pull the results later, this is a good way to go.

### How did you calculate the result URL?

Just SHA1 the string <tt>key</tt> plus <tt>guid</tt>. No salt or separators or anything, just <tt>86f7e437faa5a7fce15d1ddcb9eaeaea377667b8MyFavoriteCar</tt> in this case.

{% highlight console %}
ruby-1.8.7-head > require 'digest/sha1'
 => true 
ruby-1.8.7-head > Digest::SHA1.hexdigest('86f7e437faa5a7fce15d1ddcb9eaeaea377667b8MyFavoriteCar')
 => "745c4bcda8234186178e8430ae55f38913a5f042"
{% endhighlight %}

### Other notes

* We host the storage on [Amazon S3](http://aws.amazon.com/s3), so you'll benefit from high-availability there too.
* If you're using Ruby, you can use our [carbon gem](http://rubygems.org/gems/carbon) with the <tt>:guid</tt> option.
* If you would rather have us POST the result back to your waiting servers, you can pass <tt>&callback=http%3A%2F%2Fmyserver.example.com%2Fcallback-receiver.php</tt>.
