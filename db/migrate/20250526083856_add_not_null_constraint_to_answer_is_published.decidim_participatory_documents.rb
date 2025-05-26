# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20240327144404)
# This migration comes from decidim_participatory_documents (originally 20240327144404)

class AddNotNullConstraintToAnswerIsPublished < ActiveRecord::Migration[6.1]
  def change
    change_column_null :decidim_participatory_documents_suggestions, :answer_is_published, false
  end
end
