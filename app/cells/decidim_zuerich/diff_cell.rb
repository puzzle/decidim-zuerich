# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @cbeltrame, check for 0.27.4 upgrade

module DecidimZuerich
  module DiffCell

    # Remove the HTML view mode
    def show_html_view_dropdown?
      false
    end
  end
end
