# frozen_string_literal: true

# Remove expired download your data files
class RemoveExpiredDownloadYourDataFilesJob < CronJob
  self.cron_expression = '0 0 * * *'

  def perform
    run_rake_task('decidim:delete_download_your_data_files')
  end
end
