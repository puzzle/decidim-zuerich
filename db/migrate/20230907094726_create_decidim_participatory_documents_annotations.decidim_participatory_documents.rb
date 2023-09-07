# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20221115233022)

class CreateDecidimParticipatoryDocumentsAnnotations < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_participatory_documents_annotations do |t|
      t.references :section, null: false, index: { name: "decidim_pd_annotation_section" }
      t.jsonb :rect, default: {}
      t.integer :page_number, default: 1

      t.timestamps
    end
  end
end
