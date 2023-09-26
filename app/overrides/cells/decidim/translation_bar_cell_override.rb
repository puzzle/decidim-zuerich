# frozen_string_literal: true

# Override last checked at: 31.07.2023
Decidim::TranslationBarCell.class_eval do
  # Only display the translation banner if we are not browsing in a locale other than
  # the default locale of the tenant
  def renderable?
    Decidim.config.enable_machine_translations &&
      model.enable_machine_translations &&
      I18n.locale.to_s != model.default_locale
  end
end
