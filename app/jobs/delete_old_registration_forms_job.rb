# frozen_string_literal: true

# Delete old registrations forms
class DeleteOldRegistrationFormsJob < CronJob
  self.cron_expression = '3 0 * * *'

  def perform
    run_rake_task('decidim_meetings:clean_registration_forms')
  end
end
