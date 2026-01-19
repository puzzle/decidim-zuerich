# frozen_string_literal: true

# Send notification mail digest weekly on saturdays
class SendNotificationMailDigestWeeklyJob < CronJob
  self.cron_expression = '5 0 * * 6'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:mailers:notifications_digest_weekly'].invoke

    true
  end
end
