# frozen_string_literal: true

# Checks validating initiatives and moves all without changes for a configured time to discarded state
class MoveUnupdatedToDiscardedJob < CronJob
  self.cron_expression = '0 7 * * * '

  def perform
    run_rake_task('decidim_initiatives:check_validating')
  end
end
