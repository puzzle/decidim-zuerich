# frozen_string_literal: true

# Decidim::Proposals::PublishProposalEvent.class_eval do
#   def i18n_options
#     return super unless author.present?
#     author_path = link_to("@#{author_nickname}", profile_path(author_nickname))
#     author_string = "#{author.name} #{author_path}"
#     super.merge({ author: author_string })
#   end
# end
