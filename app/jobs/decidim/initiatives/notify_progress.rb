# frozen_string_literal: true

# Notifies progress on published initiatives
class MetricsJob < CronJob
  self.cron_expression = '0 8 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim_initiatives:notify_progress'].invoke

    true
  end
end
