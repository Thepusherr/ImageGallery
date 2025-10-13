module ExternalAssetsHelper
  def external_stylesheets
    [
      "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;500&display=swap",
      "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
      "https://unpkg.com/filepond/dist/filepond.css",
      "https://cdn.jsdelivr.net/npm/glightbox/dist/css/glightbox.min.css",
      "https://cdn.jsdelivr.net/npm/swiper@11.1.9/swiper-bundle.min.css",
      "https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css",
      "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css",
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
    ]
  end

  def external_stylesheets_tags
    external_stylesheets.map do |href|
      case href
      when /bootstrap\.min\.css/
        link_to("", href, 
          rel: "stylesheet", 
          integrity: "sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH", 
          crossorigin: "anonymous")
      when /font-awesome/
        link_to("", href, 
          rel: "stylesheet", 
          integrity: "sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==", 
          crossorigin: "anonymous")
      else
        link_to("", href, rel: "stylesheet")
      end
    end.join.html_safe
  end

  def external_scripts
    [
      {
        src: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js",
        integrity: "sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz",
        crossorigin: "anonymous"
      },
      {
        src: "https://cdn.jsdelivr.net/gh/mcstudios/glightbox/dist/js/glightbox.min.js"
      },
      {
        src: "https://cdn.jsdelivr.net/npm/swiper@11.1.9/swiper-bundle.min.js"
      },
      {
        src: "https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js",
        defer: true
      }
    ]
  end

  def external_scripts_tags
    external_scripts.map do |script|
      options = { src: script[:src] }
      options[:integrity] = script[:integrity] if script[:integrity]
      options[:crossorigin] = script[:crossorigin] if script[:crossorigin]
      options[:defer] = script[:defer] if script[:defer]
      
      content_tag(:script, "", options)
    end.join.html_safe
  end
end
