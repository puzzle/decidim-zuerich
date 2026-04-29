# frozen_string_literal: true

# Compute metrics
class ComputeMetricsJob < CronJob
  self.cron_expression = '1 0 * * *'

  def perform
    run_rake_task('decidim:metrics:all')
  end
end
