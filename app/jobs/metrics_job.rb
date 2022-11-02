# frozen_string_literal: true

# This job runs all Decidim metrics updates at midnight
class MetricsJob < CronJob
  self.cron_expression = '0 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:metrics:all'].execute

    true
  end
end
