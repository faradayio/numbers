---
title: Using web services from Excel
author: Seamus
layout: post
categories: technology
---

### Of course it's easy in Google Docs... ###

Still, I got pretty excited when I saw this for the first time:

<div class="wide" style="margin-top: 15px;">
  <a href="https://spreadsheets.google.com/ccc?key=0AkCJNpm9Ks6JdGdTMXBwbU8xNHYyZXdnWXZoSjNMZ2c&amp;hl=en&amp;authkey=CMeIkagE"><img src="/images/2011-01-06-using-web-services-from-excel/google-docs-importXML.png" alt="screenshot of Google Docs spreadsheet using importXML" /></a>
</div>

In Google Docs, `importXML` lets you read XML from a web service and then use XPath to select particular elements:

    =importXML(A4, "//emission_estimate/emission")

where `A4` is the URL [http://carbon.brighterplanet.com/flights.xml?origin_airport=MSN&destination_airport=ORD](http://carbon.brighterplanet.com/flights.xml?origin_airport=MSN&destination_airport=ORD])... yielding `327.4` kilos of carbon emissions or so.

### What about Excel? ###

I first looked for an equivalent to `XMLHttpRequest` for Excel. A [helpful StackOverflow post about `Msxml2.ServerXMLHTTP` and `WinHttp.WinHttpRequest.5.1`](http://stackoverflow.com/questions/158633/how-can-i-send-an-http-post-request-to-a-server-from-excel-using-vba) got me started, but they're Windows only. You'll get errors about `ActiveX can't create object`.

Then, thanks to [an excellent tip from Kennedy27](http://discussions.apple.com/thread.jspa?threadID=2106568), I found `QueryTables`:

{% highlight vbnet %}
With ActiveSheet.QueryTables.Add(Connection:="URL;http://carbon.brighterplanet.com/flights.txt", Destination:=Range("A2"))
    .PostText = "origin_airport=MSN&destination_airport=ORD"
    .RefreshStyle = xlOverwriteCells
    .SaveData = True
    .Refresh
End With
{% endhighlight %}

I wrote a VBA function called `GetEmissionEstimate` and voilà!

<div class="wide" style="margin-top: 15px;">
  <img src="/images/2011-01-06-using-web-services-from-excel/excel-querytables.png" alt="screenshot of Excel for Mac 2011 using Querytables from VBA" />
</div>

It took me a while to remember that Excel is essentially functional programming, so the key to getting the result to auto-refresh is to make sure the output of your VBA function is entirely dependent on the input:

<div class="wide" style="margin-top: 15px;">
  <img src="/images/2011-01-06-using-web-services-from-excel/excel-querytables-showing-dependencies.png" alt="screenshot showing that arguments to VBA function entirely determine its output" />
</div>

Now if I change the destination airport, the emission estimate will automatically update.
