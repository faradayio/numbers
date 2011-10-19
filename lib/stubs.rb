module Link
  def link_to(text, url, options = {})
    "<a href=\"#{url}\"#{ ' title="' + options[:title] + '"' if options[:title]}>#{text}</a>"
  end
  def link_to_homesite(text, path = '')
    link_to text, 'http://brighterplanet.com/' + path
  end
end

class Header
  include Link
  
  def render(options)
    if options[:partial].include? 'title' 
      "{% include title.html %}"
    elsif options[:partial].include? 'nav'
      "{% include nav.html %}"
    end
  end

  def flash
    {}
  end
  
  def get_binding
    binding
  end
end

class Nav
  include Link

  def get_binding
    binding
  end
end

class Footer
  include Link
  
  def render(*args)
    "{% include nav.html %}"
  end

  def get_binding
    binding
  end
end

class BrighterPlanet
  def self.layout; Layout end
  class Layout
    def self.application; self end
    def self.google_analytics_ua_number; 'UA-1667526-19' end
  end
  def self.metadata; Metadata end
  class Metadata
    def self.emitters
      %w{ Automobile AutomobileTrip BusTrip Computation Diet ElectricityUse Flight FuelPurchase Lodging Meeting Motorcycle Pet Purchase RailTrip Residence Shipment }
    end
  end
end

class GoogleAnalytics
  def javascript_tag(&blk)
    @output << '<script type="text/javascript">'
    yield
    @output << '</script>'
  end
  
  def get_binding
    binding
  end
end

class String
  def html_safe
    self
  end
  def underscore
    word = to_s.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
  def humanize
    result = to_s.dup
    result.gsub(/_/, " ").capitalize
  end
end

class Rails
  class << self
    def env
      self
    end
    def production?
      true
    end
  end
end
