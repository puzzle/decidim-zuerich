# frozen_string_literal: true

# Delete old registrations forms
class DeleteOldRegistrationFormsJob < CronJob
  self.cron_expression = '3 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim_meetings:clean_registration_forms'].invoke

    true
  end
end
