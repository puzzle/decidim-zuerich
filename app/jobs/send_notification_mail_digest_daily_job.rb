# frozen_string_literal: true

# Send notification mail digest daily
class SendNotificationMailDigestDailyJob < CronJob
  self.cron_expression = '5 0 * * *'

  def perform
    Rails.application.load_tasks
    # Rake::Task['decidim:mailers:notifications_digest_daily'].invoke
    Rake::Task['decidim_zuerich:mailers:notifications_digest_daily'].invoke

    true
  end
end
