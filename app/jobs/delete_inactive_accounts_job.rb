# frozen_string_literal: true

# Automatic deletion of inactive accounts
class DeleteInactiveAccountsJob < CronJob
  self.cron_expression = '0 0 * * *'

  def perform
    run_rake_task('decidim:participants:delete_inactive_participants')
  end
end
