# frozen_string_literal: true

Decidim::ContentRenderers::HashtagRenderer.const_set(
  :GLOBAL_ID_REGEX,
  %r{gid://(?!.*gid://)[\w-]*/Decidim::Hashtag/(\d+)/?(_?)([[:alnum:]](?:[[:alnum:]]|_)*)?\b}.freeze
)
