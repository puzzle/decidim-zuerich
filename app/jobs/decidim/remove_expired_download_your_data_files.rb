# frozen_string_literal: true

# Remove expired download your data files
class MetricsJob < CronJob
  self.cron_expression = '0 0 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:delete_download_your_data_files'].invoke

    true
  end
end
