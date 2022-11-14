# frozen_string_literal: true

Decidim::ParticipatoryProcesses::ParticipatoryProcessesController.class_eval do
  helper_method :participatory_process_groups,
                :filtered_processes,
                :participatory_processes,
                :has_landing_page

  private

  def collection
    # Don't include process groups in this list
    @collection ||= participatory_processes
  end

  def has_landing_page(process_group)
    Decidim::ContentBlock
      .published
      .for_scope(:participatory_process_group_homepage, organization: current_organization)
      .where(scoped_resource_id: process_group.id)
      .exists?
  end
end
