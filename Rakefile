require 'rake'
require 'net/http'
require 'uri'
require 'erb'
require 'lib/stubs'

namespace :layout do
  task :build do
    File.open File.join(File.dirname(__FILE__), '_includes', 'header.html'), 'w' do |f|
      f.puts ERB.new(Net::HTTP.get(URI.parse('http://github.com/brighterplanet/brighter_planet_layout/raw/master/app/views/layouts/_header.html.erb'))).result(Header.new.get_binding)
    end

    File.open File.join(File.dirname(__FILE__), '_includes', 'footer.html'), 'w' do |f|
      f.puts ERB.new(Net::HTTP.get(URI.parse('http://github.com/brighterplanet/brighter_planet_layout/raw/master/app/views/layouts/_footer.html.erb'))).result(Footer.new.get_binding)
    end

    File.open File.join(File.dirname(__FILE__), '_includes', 'google_analytics.html'), 'w' do |f|
      f.puts ERB.new(Net::HTTP.get(URI.parse('http://github.com/brighterplanet/brighter_planet_layout/raw/master/app/views/layouts/_google_analytics.html.erb')), nil, nil, '@output').result(GoogleAnalytics.new.get_binding)
    end

    File.open File.join(File.dirname(__FILE__), 'stylesheets', 'brighter_planet.css'), 'w' do |f|
      f.puts Net::HTTP.get(URI.parse('http://github.com/brighterplanet/brighter_planet_layout/raw/master/public/stylesheets/brighter_planet.css'))
    end
    
    %w(bg cards meter gears logo radiant_earth-small).each do |image|
      File.open File.join(File.dirname(__FILE__), 'stylesheets', 'images', "#{image}.png"), 'wb' do |f|
        f.puts Net::HTTP.get(URI.parse("http://github.com/brighterplanet/brighter_planet_layout/raw/master/public/stylesheets/images/#{image}.png"))
      end
    end
    
    File.open File.join(File.dirname(__FILE__), 'favicon.ico'), 'wb' do |f|
      f.puts Net::HTTP.get(URI.parse("http://github.com/brighterplanet/brighter_planet_layout/raw/master/public/favicon.ico"))
    end
  end
end
