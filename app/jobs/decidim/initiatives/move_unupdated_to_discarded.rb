# frozen_string_literal: true

# Checks validating initiatives and moves all without changes for a configured time to discarded state
class MetricsJob < CronJob
  self.cron_expression = '0 7 * * * '

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim_initiatives:check_validating'].invoke

    true
  end
end
