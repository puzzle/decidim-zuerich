# frozen_string_literal: true

module DecidimZuerich
  module Surveys
    # A custom mailer for sending notifications to survey admins when users fill the survey.
    module SurveyConfirmationMailer
      private

      def add_file_with_answers(answers)
        export_name = t('decidim.surveys.survey_confirmation_mailer.export_name')
        serializer = Decidim::Forms::UserAnswersSerializer

        export_data = export_file(answers, serializer)

        filename = export_data.filename(export_name)
        filename_without_extension = export_data.filename(export_name, extension: false)

        attachments["#{filename_without_extension}.zip"] =
          ::Decidim::FileZipper.new(filename, export_data.read).zip
      end

      def export_file(answers, serializer)
        Decidim::Exporters::FormPDF.new(answers, serializer).export
      rescue StandardError
        Decidim::Exporters::CSV.new(answers, serializer).export
      end
    end
  end
end
