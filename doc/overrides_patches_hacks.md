# Overrides / Patches / Hacks
Hier sammeln wir alle Fixes zusammen mit den Gründen warum wir sie brauchen und wann sie entfernt werden können.

# Beispiel
| Pfad                                         | Grund                             | Bis wann?                                                | Commit                                                 | Anmerkungen |
| -------------------------------------------- | --------------------------------- | -------------------------------------------------------- | ------------------------------------------------------ | ----------- |
| [fix_override.rb](/pfad/zum/fix_override.rb) | Fix für die Sortierung von Fixes. | Merge von [PR #123](https://github.com/projekt/pull/123) | [asdf](https://github.com/company/project/commit/asdf) | -           |

# Aktuelle Fixes
| Pfad                                                                                                                  | Grund                 | Bis wann?        | Commit | Anmerkungen        |
| --------------------------------------------------------------------------------------------------------------------- | --------------------- | ---------------- | ------ | ------------------ |
| [show.erb](app/cells/decidim/follow_button/show.erb)                                                                  | ?                     | ?                | ?      | -                  |
| [diff_cell.rb](app/cells/decidim_zuerich/diff_cell.rb)                                                                | ?                     | ?                | ?      | -                  |
| [status_controller.rb](app/controllers/status_controller.rb)                                                          | ?                     | ?                | ?      | -                  |
| [create_debate_event.rb](app/events/decidim_zuerich/debates/create_debate_event.rb)                                   | ?                     | ?                | ?      | -                  |
| [map_helper.rb](app/helpers/decidim/geolocalizables/map_helper.rb)                                                    | ?                     | ?                | ?      | -                  |
| [assemblies_helper.rb](app/helpers/decidim_zuerich/assemblies/assemblies_helper.rb)                                   | ?                     | ?                | ?      | -                  |
| [application_helper.rb](app/helpers/application_helper.rb)                                                            | ?                     | ?                | ?      | -                  |
| [decidim_zuerich/application_mailer.rb](app/mailers/decidim_zuerich/application_mailer.rb)                            | ?                     | ?                | ?      | -                  |
| [application_mailer.rb](app/mailers/application_mailer.rb)                                                            | ?                     | ?                | ?      | -                  |
| [omniauth_registrations_controller.rb](app/overrides/controllers/decidim/devise/omniauth_registrations_controller.rb) | ?                     | ?                | ?      | -                  |
| [translation_form_override.rb](app/overrides/forms/decidim/term_customizer/admin/translation_form_override.rb)        | ?                     | ?                | ?      | -                  |
| [permissions.rb](app/permissions/decidim_zuerich/participatory_processes/permissions.rb)                              | ?                     | ?                | ?      | -                  |
| [swisstopo.rb](app/provider/decidim/map/provider/dynamic_map/swisstopo.rb)                                            | ?                     | ?                | ?      | -                  |
| [oidc.rb](app/provider/omni_auth/strategies/oidc.rb)                                                                  | ?                     | ?                | ?      | -                  |
| [open_data_exporter.rb](app/services/decidim/open_data_exporter.rb)                                                   | ?                     | ?                | ?      | -                  |
| [scope_types/index.html.erb](app/views/decidim/admin/scope_types/index.html.erb)                                      | Fix für Server Fehler | Update zu 0.24.3 | ?      | Polymorphic Routes |
| [groups/_form.html.erb](app/views/decidim/groups/_form.html.erb)                                                      | ?                     | ?                | ?      | -                  |
| [proposals/_filters.html.erb](app/views/decidim/proposals/proposals/_filters.html.erb)                                | ?                     | ?                | ?      | -                  |
| [shared/_static_map.html.erb](app/views/decidim/shared/_static_map.html.erb)                                          | ?                     | ?                | ?      | -                  |
| [decidim/_main_footer.html.erb](app/views/layouts/decidim/_main_footer.html.erb)                                      | ?                     | ?                | ?      | -                  |
| [decidim/_mini_footer.html.erb](app/views/layouts/decidim/_mini_footer.html.erb)                                      | ?                     | ?                | ?      | -                  |
| [decidim/_process_header_steps.html.erb](app/views/layouts/decidim/_process_header_steps.html.erb)                    | ?                     | ?                | ?      | -                  |
| [decidim/_wrapper.html.erb](app/views/layouts/decidim/_wrapper.html.erb)                                              | ?                     | ?                | ?      | -                  |
| [decidim/mailer.html.erb](app/views/layouts/decidim/mailer.html.erb)                                                  | ?                     | ?                | ?      | -                  |
| [decidim/newsletter_base.html.erb](app/views/layouts/decidim/newsletter_base.html.erb)                                | ?                     | ?                | ?      | -                  |
| [layouts/mailer.html.erb](app/views/layouts/mailer.html.erb)                                                          | ?                     | ?                | ?      | -                  |
| [decidim_zuerich_customization.rb](config/initializers/decidim_zuerich_customization.rb)                              | ?                     | ?                | ?      | -                  |

# Archivierte Fixes
| Grund | Commit | Anmerkungen |
| ----- | ------ | ----------- |
