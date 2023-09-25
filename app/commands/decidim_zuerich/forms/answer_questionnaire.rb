# frozen_string_literal: true

# Override last checked at: 31.07.2023
module DecidimZuerich
  module Forms
    module AnswerQuestionnaire
      def answer_questionnaire
        super
        if try(:current_component)&.manifest_name == 'surveys'
          component = current_component
          email = component.try(:settings).try(:notified_email)
          id = form.context.session_token

          if email.present?
            DecidimZuerich::Surveys::SurveyAnsweredMailer.answered(email, component, id).deliver_now
          end
        end
      end
    end
  end
end