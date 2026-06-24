# frozen_string_literal: true

module DecidimZuerich
  module Verifications
    module EphemeralSms
      class MobilePhoneForm < Decidim::Verifications::Sms::MobilePhoneForm
        def handler_name
          AUTHORIZATION_NAME
        end

        AUTHORIZATION_NAME = "ephemeral_sms_authorization_handler"
      end
    end
  end
end
