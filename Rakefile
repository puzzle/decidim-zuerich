# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# Needed for inline picture migrations
def rewrite_value(value, user)
  return if value.blank?

  if value.is_a?(Hash)
    value.transform_values do |nested_value|
      rewrite_value(nested_value, user)
    end
  else
    parser = Decidim::ContentParsers::InlineImagesParser.new(value, user: user)
    parser.rewrite
  end
end
