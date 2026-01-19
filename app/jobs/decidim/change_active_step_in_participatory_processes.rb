# frozen_string_literal: true

# Change active step in participatory processes
class MetricsJob < CronJob
  self.cron_expression = '*/15 * * * *'


  def perform
    Rails.application.load_tasks
    Rake::Task['decidim_participatory_processes:change_active_step'].invoke

    true
  end
end
