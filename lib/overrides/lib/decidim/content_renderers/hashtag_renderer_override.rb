# frozen_string_literal: true

# TODO remove this after upgrading to decidim 0.26

Kernel::silence_warnings do
  Decidim::ContentRenderers::HashtagRenderer.const_set(
    :GLOBAL_ID_REGEX,
    %r{gid://(?!.*gid://)[\w-]*/Decidim::Hashtag/(\d+)/?(_?)([[:alnum:]](?:[[:alnum:]]|_)*)?\b}.freeze
  )
end
