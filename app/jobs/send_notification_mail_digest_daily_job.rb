# frozen_string_literal: true

# Send notification mail digest daily
class SendNotificationMailDigestDailyJob < CronJob
  self.cron_expression = '5 0 * * *'

  def perform
    # run_rake_task('decidim:mailers:notifications_digest_daily')
    run_rake_task('decidim_zuerich:mailers:notifications_digest_daily')
  end
end
