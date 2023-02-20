class AddTenantTypeToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_organizations, :tenant_type, :string
  end
end
