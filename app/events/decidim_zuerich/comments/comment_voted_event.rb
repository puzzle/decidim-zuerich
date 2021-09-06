# frozen_string_literal: true

# Applies the fix from https://github.com/decidim/decidim/pull/7880
# Will be obsolete in decidim 0.25
module DecidimZuerich
  module Comments
    module CommentVotedEvent
      extend ActiveSupport::Concern

      included do
        def initialize(resource:, event_name:, user:, user_role: nil, extra: nil)
          resource = target_resource(resource)
          super
        end

        def target_resource(t_resource)
          t_resource.is_a?(Decidim::Comments::Comment) ? t_resource.root_commentable : t_resource
        end
      end

    end
  end
end
