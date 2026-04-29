# frozen_string_literal: true

# Notifies progress on published initiatives
class NotifyProgressJob < CronJob
  self.cron_expression = '0 8 * * *'

  def perform
    run_rake_task('decidim_initiatives:notify_progress')
  end
end
