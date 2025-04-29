# frozen_string_literal: true

module DecidimZuerich
  class DecidimCustomization
    # This module provides methods to load customizations
    module Load
      def load_customizations
        ignore_override_paths

        return if disabled?

        load_includes
        load_prepends
        load_overrides
      end

      def load_includes(includes = @includes)
        load_unless_disabled(includes) do |base, addition|
          base.include addition
        end
      end

      def load_prepends(prepends = @prepends)
        load_unless_disabled(prepends) do |base, addition|
          base.prepend addition
        end
      end

      def ignore_override_paths(paths = @overrides)
        override_paths(paths).each do |p|
          Rails.autoloaders.main.ignore(p)
        end
      end

      def load_overrides(paths = @overrides)
        paths =
          override_files_for_paths(paths)
          .reject { |p| p.in? disabled }

        Rails.application.config.after_initialize do
          paths.each do |override|
            load override
          end
        end

        paths
      end

      private

      def override_paths(overrides = @overrides)
        overrides.map { |p| Pathname.new(p) }
      end

      def override_files_for_paths(paths = @overrides)
        override_paths(paths)
          .map { |p| p.glob('**/*_override.rb') }
          .flatten
          .map { |p| p.expand_path.to_s }
      end

      def disabled?
        return true if @disabled == true

        ENV.fetch('DISABLE_CUSTOMIZATION', '').in? %w[true t enable enabled 1]
      end

      def disabled
        disabled = ENV.fetch('DISABLE_CUSTOMIZATION', '').split(',')
        [@disabled, disabled].flatten
      end

      def load_unless_disabled(array)
        array.each do |base, addition|
          yield(base, addition) unless addition.to_s.in?(disabled)
        end
      end
    end
  end
end
