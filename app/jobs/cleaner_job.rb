# frozen_string_literal: true

# This job runs all Decidim cleaner jobs at 01:00 every sunday
class CleanerJob < CronJob
  self.cron_expression = '0 1 * * 0'

  def perform
    Decidim::Cleaner::CleanAdminLogsJob.perform_now
    Decidim::Cleaner::CleanInactiveUsersJob.perform_now
  end
end
