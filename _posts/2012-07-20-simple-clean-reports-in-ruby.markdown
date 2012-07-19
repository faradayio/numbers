---
title: Simple, clean reports in Ruby
author: Seamus
layout: post
categories: technology techresearch
---

Our [`report`](https://github.com/seamusabshere/report) library for Ruby is the shortest path between

    mysql> select * from employees;
    +----+------------+-----------+---------+------------+---------+
    | id | first_name | last_name | salary  | birthdate  | role    |
    +----+------------+-----------+---------+------------+---------+
    |  1 | Deirdre    | Irish     |   45000 | 1960-09-10 | Liaison |
    |  2 | Gregor     | German    | 16000.5 | 1950-09-09 | Tech    |
    |  3 | Spence     | Scot      |    5000 | 1955-12-11 | Joker   |
    |  4 | Vincent    | French    | 8000.99 | 1947-04-17 | Fixer   |
    |  5 | Sam        | American  | 16000.5 | 1930-04-02 | Planner |
    +----+------------+-----------+---------+------------+---------+

and simple, clean reports like

<p>
  <a href="/images/2012-07-20-simple-clean-reports-in-ruby/tps.xlsx" title=".xlsx version of the TPS report">
    <img src="/images/2012-07-20-simple-clean-reports-in-ruby/tps.xlsx.thumb.png" alt="screenshot of the .xlsx version of the TPS report" />
  </a>
</p>

<!-- more start -->

### 90% of the way by default ####

Did you notice these little details?

1. __Business-class typography__: Arial 10pt, left-aligned text and dates, right-aligned numbers and currency
2. __Auto-fit to contents__: always enabled
3. __Autofilters__: always added to your column headers
4. __Freeze pane__: always frozen beneath your column headers

Here's the code that generated it:

{% highlight ruby %}
class Tps < Report
  table 'Hierarchy' do
    head do
      row 'TPS code', :code
      row 'Date', :date
      row 'Section', 'Hierarchy'
    end
    body do
      rows :employees, ['last_name ASC']
      column('Full name') { first_name + ' ' + last_name }
      column 'Role'
      column 'Salary', :type => :Currency
    end
  end
  table 'Seniority' do
    head do
      row 'TPS code', :code
      row 'Date', :date
      row 'Section', 'Seniority'
    end
    body do
      rows :employees, ['birthdate DESC']
      column('Full name') { first_name + ' ' + last_name }
      column 'Birthdate'
      column 'Over 70?'
    end
  end
  attr_reader :code
  def initialize(code)
    @code = code
  end
  def employees(order)
    Employee.order(order).each { |employee| yield employee }
  end
  def date
    Date.today
  end
end
{% endhighlight %}

### Three output formats: XLSX, PDF, and CSV ###

You've already seen the XLSX output format - it's currently the most advanced.

The PDF output format starts each table on its own page:

<p>
  <a href="/images/2012-07-20-simple-clean-reports-in-ruby/tps.pdf" title=".pdf version of the TPS report">
    <img src="/images/2012-07-20-simple-clean-reports-in-ruby/tps.pdf.thumb.png" alt="screenshot of the .pdf version of the TPS report" />
  </a>
</p>

The CSV output format puts each table into its own file:

{% highlight csv %}
TPS code,ABC123
Date,2012-07-19
Section,Hierarchy

Full name,Role,Salary
Sam American,Planner,16000.5
Vincent French,Fixer,8000.99
Gregor German,Tech,16000.5
Deirdre Irish,Liaison,45000.0
Spence Scot,Joker,5000.0
{% endhighlight %}

<p>
  <a href="/images/2012-07-20-simple-clean-reports-in-ruby/tps0.csv">tps0.csv</a>
  <a href="/images/2012-07-20-simple-clean-reports-in-ruby/tps1.csv">tps1.csv</a>
</p>

### How the DSL works ###

See the following for a line-by-line analysis...

{% highlight ruby %}
# don't forget to inherit from Report
class Tps < Report

  # this is the sheet name in excel
  table 'Hierarchy' do

    head do
      # calling Tps#code
      row 'TPS code', :code

      # calling Tps#date
      row 'Date', :date

      # no calls are made
      row 'Section', 'Hierarchy'
    end

    body do
      # Tps#employees('last_name ASC')
      rows :employees, ['last_name ASC']

      # instance_eval'ing the proc on Employee... getting Employee#first_name + ' ' + Employee#last_name
      column('Full name') { first_name + ' ' + last_name }

      # Employee#role
      column 'Role'

      # formatted as currency where available (currently only XLSX output)
      column 'Salary', :type => :Currency
    end
  end
{% endhighlight %}

### Header and footer print styles ###

You can apply formatting to the XLSX and PDF output formats according to what the underlying libraries support:

{% highlight ruby %}
class Tps < Report
  # [...]

  # Where 72 = 1 inch
  format_pdf(
    :stamp => File.expand_path('../acme_letterhead/report_template_landscape.pdf', __FILE__),
    :body => { :width => (10*72), :header => true },
    :document => {
      :top_margin => 118,
      :right_margin => 36,
      :bottom_margin => 72,
      :left_margin => 36,
      :page_layout => :landscape,
    }
  )

  # Whatever is supported by https://github.com/seamusabshere/xlsx_writer
  format_xlsx do |xlsx|
    xlsx.quiet_booleans!
    acme_logo = xlsx.add_image(File.expand_path('../acme_letterhead/acme_logo.emf', __FILE__), 118, 107)
    acme_logo.croptop = '11025f'
    acme_logo.cropleft = '9997f'
    brighterplanet_logo = xlsx.add_image(File.expand_path('../acme_letterhead/brighterplanet_logo.emf', __FILE__), 116, 36)
    xlsx.header.left.contents = acme_logo
    xlsx.header.right.contents = 'Corporate TPS Reporting Program'
    xlsx.footer.left.contents = 'Confidential'
    xlsx.footer.center.contents = [ 'Powered by ', brighterplanet_logo ]
    xlsx.footer.right.contents = :page_x_of_y
    xlsx.page_setup.top = 1.5
    xlsx.page_setup.header = 0
    xlsx.page_setup.footer = 0
  end
end
{% endhighlight %}

### Wishlist

1. Finalize the DSL - do you like it?
2. Finish documenting all the methods
3. Make sure XLSX output format renders on all versions of Microsoft Office above 2007

<!-- more end -->
