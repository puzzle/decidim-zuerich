class RevertHomepageInteractiveMap < ActiveRecord::Migration[6.1]
  require_relative '20210429220804_add_geo_json_to_scopes.decidim_homepage_interactive_map.rb'
  require_relative '20210429220805_add_geolocation_to_participatory_processes.decidim_homepage_interactive_map.rb'
  require_relative '20210429220806_add_display_linked_assemblies_to_participatory_processes.decidim_homepage_interactive_map.rb'

  def change
    revert AddDisplayLinkedAssembliesToParticipatoryProcesses
    revert AddGeolocationToParticipatoryProcesses
    revert AddGeoJsonToScopes
  end
end
