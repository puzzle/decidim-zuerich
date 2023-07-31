# frozen_string_literal: true

# Override last checked at: 31.07.2023
Decidim::ParticipatoryProcesses::ParticipatoryProcessesController.class_eval do
  helper_method :has_landing_page

  private

  def collection
    # Don't include process groups in this list
    @collection ||= paginate(Kaminari.paginate_array(participatory_processes))
  end

  def has_landing_page(process_group)
    Decidim::ContentBlock
      .published
      .for_scope(:participatory_process_group_homepage, organization: current_organization)
      .where(scoped_resource_id: process_group.id)
      .exists?
  end
end
