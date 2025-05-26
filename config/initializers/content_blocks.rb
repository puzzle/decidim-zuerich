# frozen_string_literal: true

Decidim.content_blocks.register(:homepage, :last_blog_entries) do |content_block|
  content_block.cell = "decidim/content_blocks/last_blog_posts"
  content_block.public_name_key = "decidim.content_blocks.last_blog_posts.name"
end
