#!/usr/bin/env ruby
# frozen_string_literal: true

exec('/usr/bin/env', 'rails', 'runner', $PROGRAM_NAME, *ARGV) unless defined?(Rails)

# Sets Landing Pages
class SetLandingPages
  def initialize
    @organizations = Decidim::Organization.ids
    @participatory_process_ids = Decidim::ParticipatoryProcess.ids
    @assembly_ids = Decidim::Assembly.ids
    @resources = {}
  end

  def self.run = new.run

  def run
    handle_participatory_processes
    handle_assemblies
    write_output
  end

  def handle_participatory_processes # rubocop:disable Metrics
    ids = @participatory_process_ids
    scope = 'participatory_process_homepage'
    hero = {}
    main_data = {}
    disabled = []

    @organizations.each do |org|
      ids.each do |id|
        hero[id] = enable(*params(org, id, scope, 'hero', 1))
        main_data[id] = enable(*params(org, id, scope, 'main_data', 1))
        disabled += disable(params(org, id, scope, nil, nil).first, %w[hero main_data])
      end
      @resources[:org] ||= {}
      @resources[:org][org] ||= {}
      @resources[:org][org][:participatory_processes] = { ids:, scope:, hero:, main_data:, disabled: }
    end
  end

  def handle_assemblies # rubocop:disable Metrics
    ids = @assembly_ids
    scope = 'assembly_homepage'
    hero = {}
    main_data = {}
    disabled = []

    @organizations.each do |org|
      ids.each do |id|
        hero[id] = enable(*params(org, id, scope, 'hero', 1))
        main_data[id] = enable(*params(org, id, scope, 'main_data', 2))

        disabled += disable(params(org, id, scope, nil, nil).first, %w[hero main_data])
      end
      @resources[:org] ||= {}
      @resources[:org][org] ||= {}
      @resources[:org][org][:assemblies] = { ids:, scope:, hero:, main_data:, disabled: }
    end
  end

  def write_output
    Rails.root
         .join('tmp/set_landing_page.dump')
         .binwrite(Marshal.dump(@resources))
  end

  private

  def params(decidim_organization_id, scoped_resource_id, scope_name, manifest_name, weight)
    find = { decidim_organization_id:, scoped_resource_id:, scope_name: }
    find[:manifest_name] = manifest_name if manifest_name.present?

    update = { published_at: DateTime.now }
    update[:weight] = weight if weight.present?

    [find, update]
  end

  def enable(find_params, update_params)
    Decidim::ContentBlock
      .find_or_create_by(find_params)
      .tap { _1.update(update_params) }
      .id
  end

  def disable(find_params, manifests)
    Decidim::ContentBlock
      .where(find_params)
      .where.not(manifest_name: manifests)
      .tap { _1.update_all(published_at: nil, weight: nil) } # rubocop:disable Rails/SkipsModelValidations
      .ids
  end
end

SetLandingPages.run
