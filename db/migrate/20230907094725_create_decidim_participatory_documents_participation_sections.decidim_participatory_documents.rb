# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20221115233021)

class CreateDecidimParticipatoryDocumentsParticipationSections < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_participatory_documents_sections do |t|
      t.references :document, null: false, index: { name: "decidim_pd_section_document" }
      t.jsonb :title
      t.string :state
      t.timestamps
    end
  end
end
