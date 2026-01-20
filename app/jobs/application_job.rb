# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  rescue_from(Exception) do |error|
    payload = { cgi_data: ENV.to_hash }
    payload[:code] = error.code if error.respond_to?(:code)
    payload[:data] = error.data if error.respond_to?(:data)

    Sentry.capture_exception(error, extra: payload)
    raise
  end

  # Called once by active job before perform_now, after delayed job callbacks
  def deserialize(job_data)
    super
    init_sentry_job_context(job_data)
  end

  def init_sentry_job_context(job_data)
    Sentry.configure_scope do |scope|
      scope.set_context('active_job', job_data)
    end
  end
end
