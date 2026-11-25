# frozen_string_literal: true

# This migration comes from decidim_surveys (originally 20170522075938)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddMandatoryToSurveysQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_surveys_survey_questions, :mandatory, :boolean
  end
end
