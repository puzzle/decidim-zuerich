# frozen_string_literal: true

# This validator takes care of ensuring the validated content is
# an existing address and computes its coordinates.
#
# Overridden in order to add the address suffix to the geocoder as this is
# applied directly through the validator, not throught the attribute.
class GeocodingValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if Decidim::Map.available?(:geocoding) && record.component.present?
      geocoder = geocoder_for(record.component.organization)
      coordinates = geocoder.coordinates(geocoder_value(value))

      if coordinates.present?
        record.latitude = coordinates.first
        record.longitude = coordinates.last
      else
        record.errors.add(attribute, :invalid)
      end
    else
      record.errors.add(attribute, :invalid)
    end
  end

  private

  def geocoder_for(organization)
    Decidim::Map.geocoding(organization: organization)
  end

  def geocoder_value(value_base)
    if value_base
      value_base + value_suffix
    else
      value_base
    end
  end

  def value_suffix
    suffix = Rails.application.config.address_suffix
    return ", #{suffix}" if suffix

    ""
  end
end
