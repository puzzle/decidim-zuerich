# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20221115233024)

class CreateDecidimParticipatoryDocumentsValuationAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_participatory_documents_valuation_assignments do |t|
      t.references :decidim_participatory_documents_suggestion, null: false, index: { name: "decidim_pd_valuation_assignment_suggestion" }
      t.references :valuator_role, polymorphic: true, null: false, index: { name: "decidim_pd_valuation_assignment_valuator_role" }

      t.timestamps
    end
  end
end
