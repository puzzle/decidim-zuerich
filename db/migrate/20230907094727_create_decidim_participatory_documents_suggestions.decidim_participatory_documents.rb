# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20221115233023)

class CreateDecidimParticipatoryDocumentsSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_participatory_documents_suggestions do |t|
      t.jsonb :body, null: false
      t.references :suggestable, null: false, polymorphic: true, index: { name: "decidim_pd_seggestions_suggestable" }
      t.references :decidim_author, polymorphic: true, null: false, index: { name: "decidim_pd_suggestion_author" }
      t.references :decidim_user_group, null: true, index: { name: "decidim_pd_suggestion_user_group" }
      t.string :state, default: :not_answered, index: { name: "decidim_pd_suggestion_state" }
      t.datetime :answered_at, index: { name: "decidim_pd_suggestion_answered" }
      t.boolean :answer_is_published, default: false
      t.jsonb :answer
      t.timestamps
    end
  end
end
