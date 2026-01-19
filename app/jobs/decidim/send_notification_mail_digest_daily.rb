# frozen_string_literal: true

# Send notification mail digest daily
class MetricsJob < CronJob
  self.cron_expression = '5 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:mailers:notifications_digest_daily'].invoke

    true
  end
end
