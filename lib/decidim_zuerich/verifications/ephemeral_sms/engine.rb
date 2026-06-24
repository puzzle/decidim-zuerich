# frozen_string_literal: true

module DecidimZuerich
  module Verifications
    module EphemeralSms
      # Two-step SMS verification for ephemeral (one-time) participation.
      class Engine < ::Rails::Engine
        isolate_namespace DecidimZuerich::Verifications::EphemeralSms

        config.root = Pathname.new(__dir__)

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        routes do
          resource :authorizations, only: [:new, :create, :edit, :update, :destroy], as: :authorization do
            get :renew, on: :collection
          end

          root to: "authorizations#new"
        end

        initializer "decidim_verifications_ephemeral_sms.workflow" do |_app|
          next unless Decidim.sms_gateway_service

          Decidim::Verifications.register_workflow(:ephemeral_sms_authorization_handler) do |workflow|
            workflow.ephemeral = true
            workflow.engine = DecidimZuerich::Verifications::EphemeralSms::Engine
            workflow.icon = "message-3-line"
          end
        end
      end
    end
  end
end
