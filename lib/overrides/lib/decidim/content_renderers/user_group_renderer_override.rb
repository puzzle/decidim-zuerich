# frozen_string_literal: true

# TODO remove this after upgrading to decidim 0.26

Kernel::silence_warnings do
  Decidim::ContentRenderers::UserGroupRenderer.const_set(
    :GLOBAL_ID_REGEX,
    %r{gid://[\w-]+/Decidim::UserGroup/\d+}.freeze
  )
end
