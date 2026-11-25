# frozen_string_literal: true

# This migration comes from decidim_conferences (originally 20181123124424)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class MakePriceOptionalConferenceRegistrationType < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:decidim_conferences_registration_types, :price, true)
  end
end
