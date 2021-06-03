# frozen_string_literal: true

# This override is needed to fix the UTF-8 bug in decidim_awesome
# PR: https://github.com/Platoniq/decidim-module-decidim_awesome/pull/94
# TODO: Remove this after the PR is merged
Decidim::DecidimAwesome::CustomFields.class_eval do
  def map_fields!
    return unless data

    @fields.map! do |field|
      value = data.search("##{field['name']} div")
      if value.present?
        field['userData'] = value.map { |v| v.attribute('alt')&.value || v.inner_html(encoding: 'UTF-8') }
      end
      field
    end
  end
end
