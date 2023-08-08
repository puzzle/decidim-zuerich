# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @tburkhalter Test this

module DecidimZuerich
  # A presenter to get the url or path from a resource.
  # resource - a record or array of nested records.
  module ResourceLocatorPresenter
    def member_route(route_type, options)
      options.merge!(options_for_polymorphic)

      if member_route_name == 'project' && target.is_a?(Decidim::Budgets::Project)
        member_route_for_project_path(options)
      else
        route_proxy.send("#{member_route_name}_#{route_type}", target, options)
      end
    end

    def member_route_for_project_path(options)
      route_proxy.send('budget_project_path', target.decidim_budgets_budget_id, target.id)
    end
  end
end