# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # A set of convenient methods to generate dynamic jsonb objects in a way is
  # compatilbe with Virtus and ActiveModel thus making it easy to integrate
  # into Rails forms and similar workflows.
  module NestedJsonbAttributes
    extend ActiveSupport::Concern

    class_methods do
      # Public: Mirrors Virtus `attribute` interface to define attributes in
      # custom jsonb objects.
      #
      # name - Attribute's name
      # fields - The attribute's child fields
      #
      # Example:
      #   jsonb_attribute(:settings, [['custom_setting.foo', String], [:another_setting, Boolean])
      #   # This will generate `custom_setting_foo`, `custom_setting_foo=` and
      #   # `another_setting`, `another_setting=` and will keep them
      #   # syncronized with a hash in `settings`:
      #   # settings = { "custom_setting" => { "foo" => "demo" }, "another_setting" => "demo"}
      #
      # Returns nothing.
      def nested_jsonb_attribute(name, fields, *options)
        attribute name, Hash, default: {}

        fields.each do |f, type|
          f_attr = f.to_s.gsub('.', '_')
          attribute f_attr, type, *options
          define_method f_attr do
            field = public_send(name) || {}
            field.with_indifferent_access.dig(*(f.to_s.split('.')))
          end

          define_method "#{f_attr}=" do |value|
            field = (public_send(name) || {}).clone
            keys = f.to_s.split('.')
            if value == ''
              (keys[0...-1].reduce(field) do |hash, key|
                hash[key].presence || (hash[key] = {})
              end).except(keys.last)
            else
              (keys[0...-1].reduce(field) do |hash, key|
                hash[key].presence || (hash[key] = {})
              end)[keys.last] = value
            end
            public_send("#{name}=", field)
          end
        end
      end
    end
  end
end
