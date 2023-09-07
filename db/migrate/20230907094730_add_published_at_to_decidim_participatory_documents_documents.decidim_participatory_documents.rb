# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20230616100340)

class AddPublishedAtToDecidimParticipatoryDocumentsDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_participatory_documents_documents, :published_at, :datetime
    add_index :decidim_participatory_documents_documents, :published_at
  end
end
