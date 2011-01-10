module Link
  def link_to(text, url)
    "<a href=\"#{url}\">#{text}</a>"
  end
  def link_to_homesite(text, path = '')
    link_to text, 'http://brighterplanet.com/' + path
  end
end

class Header
  include Link
  
  def render(*args)
    "{% include title.html %}"
  end

  def flash
    {}
  end
  
  def get_binding
    binding
  end
end

class Footer
  include Link
  
  def render(*args); end

  def get_binding
    binding
  end
end

class BrighterPlanetLayout
  def self.application; self end
  def self.google_analytics_ua_number; 'UA-1667526-19' end
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
