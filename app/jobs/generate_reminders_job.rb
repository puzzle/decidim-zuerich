# frozen_string_literal: true

# Generate reminders
 
class GenerateRemindersJob < CronJob
  self.cron_expression = '4 0 * * *'

  def perform
    run_rake_task('decidim:reminders:all')
  end
end
