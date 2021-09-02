# frozen_string_literal: true

Decidim::ContentRenderers::UserGroupRenderer.const_set(
  :GLOBAL_ID_REGEX,
  %r{gid://[\w-]+/Decidim::UserGroup/\d+}.freeze
)
