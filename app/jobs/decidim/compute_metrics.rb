# frozen_string_literal: true

# Compute metrics
class MetricsJob < CronJob
  self.cron_expression = '1 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:metrics:all'].invoke

    true
  end
end
