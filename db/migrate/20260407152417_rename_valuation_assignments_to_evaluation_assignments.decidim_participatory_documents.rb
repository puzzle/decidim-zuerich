# This migration comes from decidim_participatory_documents (originally 20260303220922)
class RenameValuationAssignmentsToEvaluationAssignments < ActiveRecord::Migration[7.2]
  def change
    rename_table :decidim_participatory_documents_valuation_assignments, 
                 :decidim_participatory_documents_evaluation_assignments

    rename_column :decidim_participatory_documents_evaluation_assignments,
                  :valuator_role_id,
                  :evaluator_role_id
    
    rename_column :decidim_participatory_documents_evaluation_assignments,
                  :valuator_role_type,
                  :evaluator_role_type
    
    rename_index :decidim_participatory_documents_evaluation_assignments,
                 "decidim_pd_valuation_assignment_suggestion",
                 "decidim_pd_evaluation_assignment_suggestion"

    rename_index :decidim_participatory_documents_evaluation_assignments,
                 "decidim_pd_valuation_assignment_valuator_role",
                 "decidim_pd_evaluation_assignment_evaluator_role"
  end
end
