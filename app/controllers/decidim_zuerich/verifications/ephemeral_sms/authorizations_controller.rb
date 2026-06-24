# frozen_string_literal: true

module DecidimZuerich
  module Verifications
    module EphemeralSms
      class AuthorizationsController < ApplicationController
        include Decidim::Verifications::Renewable

        helper_method :authorization

        def new
          enforce_permission_to(:create, :authorization, authorization:)

          @form = MobilePhoneForm.new
        end

        def create
          enforce_permission_to(:create, :authorization, authorization:)

          @form = MobilePhoneForm.from_params(params.merge(user: current_user))

          Decidim::Verifications::PerformAuthorizationStep.call(authorization, @form) do
            on(:ok) do
              flash[:notice] = t("authorizations.create.success", scope: "decidim.verifications.ephemeral_sms")
              authorization_method = Decidim::Verifications::Adapter.from_element(authorization.name)
              redirect_to authorization_method.resume_authorization_path(redirect_url:)
            end
            on(:invalid) do
              flash.now[:alert] = t("authorizations.create.error", scope: "decidim.verifications.ephemeral_sms")
              render :new, status: :unprocessable_entity
            end
          end
        end

        def edit
          enforce_permission_to(:update, :authorization, authorization:)

          @form = ConfirmationForm.from_params(params)
        end

        def update
          enforce_permission_to(:update, :authorization, authorization:)

          @form = ConfirmationForm.from_params(params)

          Decidim::Verifications::ConfirmUserAuthorization.call(authorization, @form, session) do
            on(:ok) do
              flash[:notice] = t("authorizations.update.success", scope: "decidim.verifications.ephemeral_sms")

              redirect_to redirect_url || decidim_verifications.authorizations_path
            end

            on(:invalid) do
              flash.now[:alert] = t("authorizations.update.error", scope: "decidim.verifications.ephemeral_sms")
              render :edit, status: :unprocessable_entity
            end
          end
        end

        def destroy
          enforce_permission_to(:destroy, :authorization, authorization:)

          authorization.destroy!
          flash[:notice] = t("authorizations.destroy.success", scope: "decidim.verifications.ephemeral_sms")

          redirect_to action: :new
        end

        private

        def authorization
          @authorization ||= Decidim::Authorization.find_or_initialize_by(
            user: current_user,
            name: AUTHORIZATION_NAME
          )
        end

        AUTHORIZATION_NAME = "ephemeral_sms_authorization_handler"
      end
    end
  end
end
