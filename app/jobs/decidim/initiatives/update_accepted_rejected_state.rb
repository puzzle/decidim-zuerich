# frozen_string_literal: true

# Checks published initiatives and moves to accepted/rejected state depending on the votes collected when the signing period has finished

class MetricsJob < CronJob
  self.cron_expression = '30 7 * * *'

  def perform
    Rails.application.load_tasks
    Rake::Task['decidim_initiatives:check_published'].invoke

    true
  end
end
