# frozen_string_literal: true

# Compute open data
 

class ComputeOpenDataJob < CronJob
  self.cron_expression = '2 0 * * *'

  def perform
    run_rake_task('decidim:open_data:export')
  end
end
