# frozen_string_literal: true

module DecidimZuerich
  module TranslationBarCell
    # Only display the translation banner if something has been machine translated
    def renderable?
      super && model.class.translatable_fields_list.any? do |field|
        model.send(field).try(:key?, 'machine_translations')
      end
    end
  end
end
