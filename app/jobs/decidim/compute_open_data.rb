# frozen_string_literal: true

# Compute open data
 

class MetricsJob < CronJob
  self.cron_expression = '2 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:open_data:export'].invoke

    true
  end
end
