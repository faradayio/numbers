---
title: Writing XLSX from Ruby
author: Seamus
layout: post
categories: technology techresearch
---

Our [`xlsx_writer`](https://github.com/seamusabshere/xlsx_writer) library for Ruby lets you create spreadsheets compatible with Microsoft Office 2007 Excel and above.

### Features

1. __Essential cell types__: general, currency, date, integer, float (decimal)
2. __Standardized formatting__: Arial 10pt, left-aligned text and dates, right-aligned numbers and currency
3. __Auto-fit to contents__: always enabled
4. __Autofilters__: just give it a range of cells
5. __Header and footer print styles__: margins, arbitrary text, page numbers, and vector logos (.emf)

<!-- more start -->

### Basic example

{% highlight ruby %}
require 'xlsx_writer'
doc = XlsxWriter::Document.new
sheet1 = doc.add_sheet 'Sheet1'
sheet1.add_row ['header1', 'header2', 'header3']
sheet1.add_row ['a', 'b', 'c']
sheet1.add_row [1, 2, 3]
require 'fileutils'
FileUtils.mv doc.path, "/path/to/desired/location"
doc.cleanup
{% endhighlight %}

### Advanced example

{% highlight ruby %}
require 'xlsx_writer'
doc = XlsxWriter::Document.new
sheet1 = doc.add_sheet("People")

# First add data...

sheet1.add_row([
  "DoB",
  "Name",
  "Occupation",
  "Salary",
  "Citations",
  "Average citations per paper"
])
sheet1.add_row([
  Date.parse("July 31, 1912"), 
  "Milton Friedman",
  "Economist / Statistician",
  {:type => :Currency, :value => 10_000},
  500_000,
  0.31
])

# Then add autofilters and page styles...

sheet1.add_autofilter 'A1:E1'

# (figure out your croptop and cropleft by mocking it up in Excel and then unzipping the xlsx file. Get the .emf files, "cropleft" (if necessary), etc. from there)

left_header_image = doc.add_image('image1.emf', 118, 107)
left_header_image.croptop = '11025f'
left_header_image.cropleft = '9997f'
center_footer_image = doc.add_image('image2.emf', 116, 36)

doc.page_setup.top = 1.5
doc.page_setup.header = 0
doc.page_setup.footer = 0
doc.header.right.contents = 'Corporate Reporting'
doc.footer.left.contents = 'Confidential'
doc.footer.right.contents = :page_x_of_y
doc.header.left.contents = left_header_image
doc.footer.center.contents = [ 'Powered by ', center_footer_image ]

# Finally you can generate the file.

require 'fileutils'
FileUtils.mv doc.path, 'myfile.xlsx'

# don't forget
doc.cleanup
{% endhighlight %}

### Debugging utilities

The library comes with two scripts:

1. __unpack.rb__: Takes an XLSX file, unzips it, and reformats the XML it contains to be more readable.
2. __repack.rb__: Takes a directory, converts the XML files to DOS line endings, and zips it into `out.xlsx`.

They have been useful in the past for debugging Excel crashes. You create a file in `xlsx_writer` and also in Excel, then unpack both of them and do a line-by-line comparison of the XML files within using `diff -r`.

<!-- more end -->