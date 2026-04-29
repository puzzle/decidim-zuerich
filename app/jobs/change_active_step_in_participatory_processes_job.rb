# frozen_string_literal: true

# Change active step in participatory processes
class ChangeActiveStepInParticipatoryProcessesJob < CronJob
  self.cron_expression = '*/15 * * * *'


  def perform
    run_rake_task('decidim_participatory_processes:change_active_step')
  end
end
