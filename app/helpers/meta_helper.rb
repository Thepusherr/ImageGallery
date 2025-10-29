# frozen_string_literal: true

module MetaHelper
  def basic_meta_tags
    content_tag(:meta, nil, content: 'text/html; charset=UTF-8', 'http-equiv' => 'Content-Type') +
      content_tag(:meta, nil, charset: 'utf-8') +
      content_tag(:meta, nil, content: 'width=device-width, initial-scale=1', name: 'viewport') +
      content_tag(:meta, nil, name: 'user-signed-in', content: user_signed_in?)
  end

  def page_title
    content_for?(:title) ? yield(:title) : 'ImageGallery'
  end

  def favicon_tags
    link_to('', asset_path('favicon.png'), rel: 'icon') +
      link_to('', asset_path('apple-touch-icon.png'), rel: 'apple-touch-icon')
  end

  def font_preconnect_tags
    link_to('', 'https://fonts.googleapis.com', rel: 'preconnect') +
      link_to('', 'https://fonts.gstatic.com', rel: 'preconnect', crossorigin: '')
  end

  def google_fonts_link
    link_to('',
            'https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Inter:wght@100;200;300;400;500;600;700;800;900&family=Cardo:ital,wght@0,400;0,700;1,400;1,700&display=swap', rel: 'stylesheet')
  end
end
