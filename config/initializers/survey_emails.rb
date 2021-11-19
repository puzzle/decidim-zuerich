# frozen_string_literal: true

component = Decidim.find_component_manifest(:surveys)
component.settings(:global) do |settings|
  settings.attribute :notified_email, type: :string
end