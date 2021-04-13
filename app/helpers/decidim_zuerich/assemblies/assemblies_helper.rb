# frozen_string_literal: true

module DecidimZuerich
  module Assemblies
    module AssembliesHelper
      extend ActiveSupport::Concern

      included do
        def assembly_features(assembly)
          ''.html_safe
        end
      end
    end
  end
end
