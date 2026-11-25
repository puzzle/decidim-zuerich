# frozen_string_literal: true

# Automatic deletion of inactive accounts
class DeleteInactiveAccounts < CronJob
  self.cron_expression = '0 0 * * *'


  def perform
    Rails.application.load_tasks
    Rake::Task['decidim:participants:delete_inactive_participants'].invoke

    true
  end
end
