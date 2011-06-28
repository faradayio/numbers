require 'rake'
require 'net/http'
require 'net/https'
require 'uri'
require 'erb'
require './lib/stubs'

def get(url)
  url = URI.parse url
  http = Net::HTTP.new(url.host, url.port)
  http.open_timeout = http.read_timeout = 10
  http.use_ssl = (url.scheme == "https")
  headers = {
    'User-Agent'          => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.12) Gecko/20080201 Firefox/2.0.0.12',
    'If-Modified-Since'   => '',
    'If-None-Match'       => ''
  }
  response, body = http.get(url.request_uri, headers)
  body
end

namespace :layout do
  task :build do
    File.open File.join(File.dirname(__FILE__), '_includes', 'header.html'), 'w' do |f|
      f.puts ERB.new(get('https://github.com/brighterplanet/brighter_planet_layout/raw/master/app/views/layouts/_header.html.erb')).result(Header.new.get_binding)
    end

    File.open File.join(File.dirname(__FILE__), '_includes', 'footer.html'), 'w' do |f|
      f.puts ERB.new(get('https://github.com/brighterplanet/brighter_planet_layout/raw/master/app/views/layouts/_footer.html.erb')).result(Footer.new.get_binding)
    end

    File.open File.join(File.dirname(__FILE__), '_includes', 'google_analytics.html'), 'w' do |f|
      f.puts ERB.new(get('https://github.com/brighterplanet/brighter_planet_layout/raw/master/app/views/layouts/_google_analytics.html.erb'), nil, nil, '@output').result(GoogleAnalytics.new.get_binding)
    end

    File.open File.join(File.dirname(__FILE__), 'stylesheets', 'brighter_planet.css'), 'w' do |f|
      f.puts get('https://github.com/brighterplanet/brighter_planet_layout/raw/master/public/stylesheets/brighter_planet.css')
    end
    
    File.open File.join(File.dirname(__FILE__), 'stylesheets', 'fonts.css'), 'w' do |f|
      f.puts get('https://github.com/brighterplanet/brighter_planet_layout/raw/master/public/stylesheets/fonts.css')
    end
    
    %w(bg cards logo radiant_earth-small glow).each do |image|
      File.open File.join(File.dirname(__FILE__), 'stylesheets', 'images', "#{image}.png"), 'wb' do |f|
        f.puts get("https://github.com/brighterplanet/brighter_planet_layout/raw/master/public/stylesheets/images/#{image}.png")
      end
    end
    
    File.open File.join(File.dirname(__FILE__), 'favicon.ico'), 'wb' do |f|
      f.puts get("https://github.com/brighterplanet/brighter_planet_layout/raw/master/public/favicon.ico")
    end
  end
end

desc "Create a new post skeleton with today's date"
task :post, :name, :author do |t, args|
  name = args[:name]
  author = args[:author]
  filename = "_posts/#{Time.now.strftime('%Y-%m-%d')}-#{name.downcase.gsub(/\s+/,'-')}.markdown"
  File.open(filename, 'w') do |f|
    f.puts <<-TEMPLATE
---
title: #{name}
author: #{author}
layout: post
categories: technology
---

Lorem ipsum

<!-- more start -->

Dolor sit amet

<!-- more end -->
    TEMPLATE
  end
  puts "I put your post in #{filename}"
end
