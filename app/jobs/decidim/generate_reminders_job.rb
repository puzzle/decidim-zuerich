# frozen_string_literal: true

# Generate reminders
 
class GenerateRemindersJob < CronJob
  self.cron_expression = '4 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:reminders:all'].invoke

    true
  end
end
