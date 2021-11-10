# frozen_string_literal: true

Decidim::ContentRenderers::UserRenderer.const_set(
  :GLOBAL_ID_REGEX,
  %r{gid://[\w-]+/Decidim::User/\d+}.freeze
)
