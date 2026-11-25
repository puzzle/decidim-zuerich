# frozen_string_literal: true

# This is the base class for all cron jobs.
#
# `db:schedule_jobs` only loads files named `app/jobs/**/*_job.rb`, so a cron
# job whose file lacks the `_job` suffix is never scheduled.
class CronJob < ApplicationJob

  class_attribute :cron_expression

  class << self
    def schedule
      set(cron: cron_expression).perform_later unless scheduled?
    end

    def remove
      delayed_job.destroy if scheduled?
    end

    def scheduled?
      delayed_job.present?
    end

    def delayed_job
      Delayed::Job
        .where('handler LIKE ?', "%job_class: #{name}%")
        .first
    end
  end

  def run_rake_task(task_name)
    Rails.logger.info "Starting Rake task: #{task_name}"

    # Run via system instead of Rake::Task['...'].invoke to avoid Rake state issues
    success = system({ "RAILS_ENV" => Rails.env }, "bundle exec rake #{task_name}",
      chdir: Rails.root)

    if success
      Rails.logger.info "Successfully completed Rake task: #{task_name}"
    else
      raise "Rake task '#{task_name}' failed with status #{$?.exitstatus}"
    end

    true
  end
end
