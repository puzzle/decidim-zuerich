# frozen_string_literal: true

# Checks published initiatives and moves to accepted/rejected state depending on the votes collected when the signing period has finished

class UpdateAcceptedRejectedStateJob < CronJob
  self.cron_expression = '30 7 * * *'

  def perform
    run_rake_task('decidim_initiatives:check_published')
  end
end
