# frozen_string_literal: true

# Overwrite LastBlogPostsHelper to use image from text if present.
# Alternatively use the first uploaded image.
module LastBlogPostsHelper
  include ApplicationHelper

  def blog_image_src(post)
    image_from_text =
        Nokogiri::HTML
            .parse(translated_attribute(post.body))
            .css('img')
            .first
            &.attr('src')

    return image_from_text if image_from_text.present?
    return post.photos.min_by(&:weight).url if post.photos.count.positive?

    'organization-default-image.png'
  end
end