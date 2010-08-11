---
title: Use Amazon SQS to get emission estimates
author: Seamus
layout: post
categories: [middleware]
---

You can queue up requests to our [emission estimate web service](http://carbon.brighterplanet.com) using [Amazon SQS](http://aws.amazon.com/sqs):

{% highlight console %}
$ curl -v https://queue.amazonaws.com/121562143717/cm1_production_incoming -X POST --data "Action=SendMessage&Version=2009-02-01&MessageBody=emitter%3Dautomobile%26make%3DNissan%26guid%3DMyFavoriteCar%26key%3D86f7e437faa5a7fce15d1ddcb9eaeaea377667b8"
* About to connect() to queue.amazonaws.com port 443 (#0)
*   Trying 72.21.211.87... connected
* Connected to queue.amazonaws.com (72.21.211.87) port 443 (#0)
* successfully set certificate verify locations:
*   CAfile: /opt/local/share/curl/curl-ca-bundle.crt
  CApath: none
* SSLv3, TLS handshake, Client hello (1):
* SSLv3, TLS handshake, Server hello (2):
* SSLv3, TLS handshake, CERT (11):
* SSLv3, TLS handshake, Server finished (14):
* SSLv3, TLS handshake, Client key exchange (16):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSL connection using RC4-MD5
* Server certificate:
* 	 subject: C=US; ST=Washington; L=Seattle; O=Amazon.com Inc.; CN=queue.amazonaws.com
* 	 start date: 2010-04-23 00:00:00 GMT
* 	 expire date: 2011-04-23 23:59:59 GMT
* 	 subjectAltName: queue.amazonaws.com matched
* 	 issuer: C=US; O=VeriSign, Inc.; OU=VeriSign Trust Network; OU=Terms of use at https://www.verisign.com/rpa (c)09; CN=VeriSign Class 3 Secure Server CA - G2
* 	 SSL certificate verify ok.
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

As you can see, the MessageBody is the url-encoded form of a querystring:

    emitter=automobile&make=Nissan&guid=MyFavoriteCar&key=86f7e437faa5a7fce15d1ddcb9eaeaea377667b8

Since we passed a key and a guid, the result will be found at

http://storage.carbon.brighterplanet.com/745c4bcda8234186178e8430ae55f38913a5f042

It will be JSON encoded.

### Why use SQS?

Depending on your environment, you may already have an excellent SQS client library. You'll have the high availability of Amazon web services combined with competitive Brighter Planet pricing for asynchronous (rather than realtime) emission estimates.

Depending on your application, set-it-and-forget-it may be a natural fit. We'll store the result for you in JSON format at an effectively randomized URL, which is perfect for AJAX calls to display results in a browser. In general, if you can queue up the emission estimate now and count on a JSON-enabled client to pull the results later, this is a good way to go.

### How did you calculate the storage URL?

ruby-1.8.7-head > Digest::SHA1.hexdigest('86f7e437faa5a7fce15d1ddcb9eaeaea377667b8MyFavoriteCar')
 => "745c4bcda8234186178e8430ae55f38913a5f042"

### Other notes

* We host the storage on Amazon S3, so you'll get high-availability there too.
* If you're using ruby, you can use our [carbon gem](http://rubygems.org/gems/carbon) with the <tt>:guid</tt> option.
