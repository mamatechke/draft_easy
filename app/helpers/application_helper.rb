module ApplicationHelper
  def hotwire_livereload_tags
    if defined?(HotwireLivereload::Helpers)
      HotwireLivereload::Helpers.hotwire_livereload_tags
    end
  end
end
