# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20221115233024)

class CreateDecidimParticipatoryDocumentsSuggestionNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_participatory_documents_suggestion_notes do |t|
      t.references :suggestion, null: false, index: { name: "decidim_pd_suggestion_note_suggestion" }
      t.references :decidim_author, null: false, index: { name: "decidim_pd_suggestion_note_author" }
      t.jsonb :body, null: false

      t.timestamps
    end
    add_column :decidim_participatory_documents_suggestions, :suggestion_notes_count, :integer, null: false, default: 0
    add_index :decidim_participatory_documents_suggestion_notes, :created_at, name: :index_decidim_pd_suggestion_notes_on_created_at
  end
end
