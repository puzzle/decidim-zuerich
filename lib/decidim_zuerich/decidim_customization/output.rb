# frozen_string_literal: true

module DecidimZuerich
  class DecidimCustomization
    # This module provides methods to output customization details
    module Output
      def puts_and_log
        return unless ENV.fetch('CUSTOMIZATION_OUTPUT', 'false').in? %w[true t enable enabled on 1]

        puts self # rubocop:disable Rails/Output

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
        char * times + "\n"
      end

      def includes_output
        return unless @includes.any?

        "  Loaded Includes:\n\t- #{@includes.map(&:second).join("\n\t- ")}\n\n#{border}"
      end

      def prepends_output
        return unless @prepends.any?

        "  Loaded Prepends:\n\t- #{@prepends.map(&:second).join("\n\t- ")}\n\n#{border}"
      end

      def overrides_output
        return unless @overrides.any?

        "  Loaded Overrides:\n\t- #{@overrides.join("\n\t- ")}\n\n#{border}"
      end
    end
  end
end
