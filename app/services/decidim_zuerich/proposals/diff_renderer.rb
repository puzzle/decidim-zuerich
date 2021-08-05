# frozen_string_literal: true

module DecidimZuerich::Proposals
  module DiffRenderer

    def parse_values(attribute, values)
      values = super
      values = values.map { |value| value[I18n.locale.to_s] } if attribute == :title
      if attribute == :body
        values = values.map do |value|
          # ActionView::Base.full_sanitizer.sanitize(value[0])
          Nokogiri::XML(value[0])
              .css('xml > dl > dt, xml > dl > dd > div')
              .map {|node| node.xpath('text()').to_s }
              .flatten
              .join("\n")
        end
      end
      values
    end

  end
end
