# frozen_string_literal: true

# This migration comes from decidim_budgets (originally 20200629072626)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class RenameBudgetToBudgetAmmount < ActiveRecord::Migration[5.2]
  def change
    rename_column :decidim_budgets_projects, :budget, :budget_amount
  end
end
