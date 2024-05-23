# frozen_string_literal: true

class CustomizationOutput
  def initialize(includes: [], prepends: [], overrides: [], color: true)
    @includes = includes
    @prepends = prepends
    @overrides = overrides
    @color = color
  end

  def self.puts_and_log(...)
    new(...).puts_and_log
  end

  def puts_and_log
    return unless ActiveRecord::Type::Boolean.new.cast(ENV['CUSTOMIZATION_OUTPUT'])

    puts to_s # rubocop:disable Rails/Output
    Rails.logger.info to_s
  end

  def to_s
    [
      color_start,
      border,
      includes_output,
      prepends_output,
      overrides_output,
      color_end
    ].join("\n").to_s
  end

  private

  def color_start
    "\033[33m" if @color
  end

  def color_end
    "\033[0m" if @color
  end

  def border(char: '=', times: 80)
    char * times
  end

  def includes_output
    return unless @includes.any?

    "Loaded Includes:\n\t- #{@includes.map(&:second).join("\n\t- ")}\n#{border}\n"
  end

  def prepends_output
    return unless @prepends.any?

    "Loaded Prepends:\n\t- #{@prepends.map(&:second).join("\n\t- ")}\n#{border}\n"
  end

  def overrides_output
    return unless @overrides.any?

    "Loaded Overrides:\n\t- #{@overrides.join("\n\t- ")}\n#{border}\n"
  end
end
