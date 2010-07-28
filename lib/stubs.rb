module Link
  def link_to(text, url)
    "<a href=\"#{url}\">#{text}</a>"
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

  def get_binding
    binding
  end
end

class GoogleAnalytics
  class Rails
    def self.application; self end
    def self.google_analytics_ua_number; 'UA-1667526-18' end
  end
  
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
