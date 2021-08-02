# frozen_string_literal: true

Decidim.content_blocks.register(:homepage, :html2) do |content_block|
  content_block.cell = "decidim/content_blocks/html"
  content_block.public_name_key = "decidim.content_blocks.html2.name"
  content_block.settings_form_cell = "decidim/content_blocks/html_settings_form"

  content_block.settings do |settings|
    settings.attribute :html_content, type: :text, translated: true
  end
end

Decidim.content_blocks.register(:homepage, :html3) do |content_block|
  content_block.cell = "decidim/content_blocks/html"
  content_block.public_name_key = "decidim.content_blocks.html3.name"
  content_block.settings_form_cell = "decidim/content_blocks/html_settings_form"

  content_block.settings do |settings|
    settings.attribute :html_content, type: :text, translated: true
  end
end

Decidim.content_blocks.register(:homepage, :html4) do |content_block|
  content_block.cell = "decidim/content_blocks/html"
  content_block.public_name_key = "decidim.content_blocks.html4.name"
  content_block.settings_form_cell = "decidim/content_blocks/html_settings_form"

  content_block.settings do |settings|
    settings.attribute :html_content, type: :text, translated: true
  end
end

Decidim.content_blocks.register(:homepage, :last_blog_entries) do |content_block|
  content_block.cell = "decidim/content_blocks/last_blog_posts"
  content_block.public_name_key = "decidim.content_blocks.last_blog_posts.name"
end
