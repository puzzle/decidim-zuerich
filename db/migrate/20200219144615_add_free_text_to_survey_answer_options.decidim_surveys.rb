# frozen_string_literal: true

# This migration comes from decidim_surveys (originally 20180405015258)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddFreeTextToSurveyAnswerOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_surveys_survey_answer_options, :free_text, :boolean
  end
end
