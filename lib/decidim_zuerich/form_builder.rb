# frozen_string_literal: true

module DecidimZuerich
  # Fixes a problem with the javascript required validation of text input fields.
  module FormBuilder
    def extract_validations(attribute, options)
      validation_options = super(attribute, options)

      validation_options[:required] = options.fetch(:required, attribute_required?(attribute))

      validation_options
    end
  end
end
