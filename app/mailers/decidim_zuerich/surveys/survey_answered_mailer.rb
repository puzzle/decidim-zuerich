# frozen_string_literal: true

module DecidimZuerich
  module Surveys
    # A custom mailer for sending notifications to survey admins when users fill the survey.
    class SurveyAnsweredMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper

      def answered(email, component, id)
        @survey_name = translated_attribute component.name
        @answers_link = Decidim::EngineRouter.admin_proxy(component).show_survey_url(id)

        # need to set the organization for asset resolution to work
        @organization = component.organization

        subject = I18n.t("answered.subject", survey_name: @survey_name, scope: "decidim_zuerich.surveys.survey_answered_mailer")
        mail(to: email, subject: subject)
      end

    end
  end
end
