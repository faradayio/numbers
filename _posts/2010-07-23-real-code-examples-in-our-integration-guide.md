---
title: Real code examples in our integration guide
author: Seamus
---

I realize that not everybody uses Ruby/Rails, so integration with our [emission estimate web service](http://carbon.brighterplanet.com) won't always be facilitated by [our sharp little carbon gem](http://rubygems.org/gems/carbon).

Still, if I were a third-party developer, there is nothing I would want more than unfiltered code examples from a real integration, no matter the language.

This is from step 4, "Prepare for network problems," of our [unfinished integration guide](http://github.com/brighterplanet/carbon/blob/master/doc/INTEGRATION_GUIDE.rdoc)

{% highlight diff %}
diff --git a/app/helpers/emitters_helper.rb b/app/helpers/emitters_helper.rb
index b5c3a1c..a0921b2 100755
--- a/app/helpers/emitters_helper.rb
+++ b/app/helpers/emitters_helper.rb
@@ -2,6 +2,39 @@
 # doc/partials_that_use_local_variables_named_after_characteristics.rb
 
 module EmittersHelper
+  def outsourced_content(failsafe = '', &block)
+    str = @failed ? failsafe : capture(&block)
+    if block_called_from_erb? block
+      concat str
+    else
+      str
+    end
+  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
+    # These are general network errors raised by Net::HTTP.
+    # Your internet connection might be down, or our servers might be down.
+    @failed = true
+    retry
+  rescue ::Carbon::RateLimited
+    # Realtime mode only.
+    # In order to prevent denial-of-service attacks, our servers rate limit requests.
+    # The gem will try up to three times to get an answer back from the server, waiting slightly longer each time.
+    # If you still get this exception, please contact us at staff@brighterplanet.com and we'll lift your rate.
+    @failed = true
+    retry
+  rescue ::Carbon::RealtimeEstimateFailed
+    # Realtime mode only.
+    # Our server returned a 4XX or 5XX error.
+    # Please contact us at staff@brighterplanet.com if you get these more than a couple times.
+    @failed = true
+    retry
+  rescue ::Carbon::QueueingFailed
+    # Async mode only.
+    # The gem connects directly to Amazon SQS in order to provide maximum throughput. If that service returns anything other than success, you get this exception.
+    # Please contact us at staff@brighterplanet.com if you see too many of these.
+    @failed = true
+    retry
+  end
+  
   def render_characteristic(emitter, characteristic)
     characteristic_value = emitter.real_or_assumed_characteristic_value(characteristic)
     locals = { :emitter => emitter, :characteristic => characteristic, characteristic => characteristic_value }
{% endhighlight %}

Is that useful? Are you used to reading diffs?
