# frozen_string_literal: true

# This improves the Pry prompt for Puzzle Rails environments
class PuzzleRailsPryPrompt
  PROJECT_NAME = 'STZH'

  ENV_NAMES    = {
    production: 'PROD',
    integration: 'INT',
    test: 'TEST',
    development: 'DEV'
  }.freeze

  COLORS = {
    production: %i[bold red],
    integration: %i[yellow],
    test: %i[blue],
    development: %i[green]
  }.freeze

  PARTS = ->(project, env) { "#{project}-#{env}" }

  def initialize(project_name: nil, env_names: nil, colors: nil)
    @project_name = project_name || ENV['PROJECT_NAME'] || PROJECT_NAME
    @env_names = env_names || ENV_NAMES
    @colors = colors || COLORS
  end

  def self.description = 'This improves the Pry prompt for Puzzle Rails environments\n[1] [project_env] pry(main)'
  def description = self.class.description


  def self.set_prompt(...) = new(...).set_prompt
  def set_prompt
    add_prompt unless prompt_exists?
    Pry.config.prompt = Pry::Prompt[:puzzle_rails]
  end

  def add_prompt # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if Pry::Prompt.respond_to?(:add)
      Pry::Prompt.add 'puzzle_rails', description, %w[> *] do |target_self, nest_level, pry, sep|
        "[#{pry.input_ring.size}] " \
          "[#{formatted_env}] " \
          "#{pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
          "#{":#{nest_level}" unless nest_level.zero?}#{sep} "
      end
    else
      draw_prompt = lambda do |target_self, nest_level, pry, sep|
        "[#{pry.input_array.size}] " \
          "[#{formatted_env}] " \
          "#{pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
          "#{":#{nest_level}" unless nest_level.zero?}#{sep} "
      end
      prompts = [
        proc do |target_self, nest_level, pry|
          draw_prompt.call(target_self, nest_level, pry, '>')
        end,
        proc do |target_self, nest_level, pry|
          draw_prompt.call(target_self, nest_level, pry, '*')
        end
      ]
      Pry::Prompt::MAP['puzzle_rails'] = { value: prompts, description: description }
    end
  end

  def formatted_env
    PARTS
      .call(PROJECT_NAME, ENV_NAMES[env])
      .then { |t| colorize(t) }
  end

  def env
    case ENV.fetch('SENTRY_CURRENT_ENV', Rails.env)
    when 'production'  then :production
    when 'integration' then :integration
    when 'test'        then :test
    else                    :development
    end
  end

  def colorize(text) = apply_helpers(text, COLORS[env])

  private

  def prompt_exists?
    Pry::Prompt.all.include?(:puzzle_rails)
  end

  def apply_helpers(obj, actions)
    actions.inject(obj) { |collection, action| Pry::Helpers::Text.send(action, collection) }
  end
end
