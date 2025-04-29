# frozen_string_literal: true

require_relative 'decidim_customization/load'
require_relative 'decidim_customization/output'

module DecidimZuerich
  # This class manages, loads and informs about the overrides to customize Decidim
  #
  # Parameters:
  #
  #   includes:
  #     Array of 2-Element Arrays, consisting of [BaseClass, IncludeClass]
  #     default: []
  #     example: [[Decidim::DiffCell, DecidimOCL::DiffCell]]
  #
  #   prepends:
  #     Array of 2-Element Arrays, consisting of [BaseClass, PrependClass]
  #     default: []
  #     example: [[Decidim::ApplicationMailer, DecidimOCL::ApplicationMailer]]
  #
  #   overrides:
  #     Array of paths, that are ignored by Zeitwerk and loaded as class_overrides
  #     default: []
  #     example: ['app/overrides']
  #
  #   disabled:
  #     Array of items to disable, either the addition as string, or the path of the override
  #     default: []
  #     example: ['DecidimOCL::DiffCell', 'app/overrides/decidim/other_override.rb']
  #
  #   color:
  #     Boolean, that controls color output
  #     default: true
  #
  # Environment Variables:
  #
  #   CUSTOMIZATION_OUTPUT:
  #     Output is only logged and printed if this is 'true'
  #
  #   DISABLE_CUSTOMIZATION:
  #     Does not load or print any customizations if this is 'true'.
  #     Alternatively it can be an array of additions/paths that are disabled.
  #     example: 'true'
  #     example: ['DecidimOCL::DiffCell', 'app/overrides/decidim/other_override.rb']
  #
  #
  class DecidimCustomization
    include Output
    include Load

    def initialize(includes: [], prepends: [], overrides: [], disabled: [], color: true)
      @includes = includes
      @prepends = prepends
      @overrides = overrides
      @disabled = disabled
      @color = color
    end

    def self.log_and_load(...) = new(...).log_and_load

    def log_and_load
      load_customizations
      puts_and_log
    end
  end
end
