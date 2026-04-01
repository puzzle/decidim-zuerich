# frozen_string_literal: true

# This migration comes from decidim_forms (originally 20180405015012)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class CreateDecidimFormsAnswerOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_forms_answer_options do |t|
      t.references :decidim_question, index: { name: "index_decidim_forms_answer_options_question_id" }
      t.jsonb :body
      t.boolean :free_text
    end
  end
end
