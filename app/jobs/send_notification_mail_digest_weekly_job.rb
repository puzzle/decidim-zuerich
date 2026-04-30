# frozen_string_literal: true

# Send notification mail digest weekly on saturdays
class SendNotificationMailDigestWeeklyJob < CronJob
  self.cron_expression = '1 4 * * 6'

  def perform
    # run_rake_task('decidim:mailers:notifications_digest_weekly')
    run_rake_task('decidim_zuerich:mailers:notifications_digest_weekly')
  end
end
