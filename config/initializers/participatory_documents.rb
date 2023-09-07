Decidim::ParticipatoryDocuments.configure do |config|
  # Public: The maximum length of any text field (body, answers, etc) to export.
  # Defaults to 50. Set to 0 to export the full text.
  config.max_export_text_length = 0

  # Public: The minimum length of a suggestion to be considered valid.
  config.min_suggestion_length = 5

  # Public: The maximum length of a suggestion to be considered valid.
  config.max_suggestion_length = 500
end
