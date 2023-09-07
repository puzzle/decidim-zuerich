# frozen_string_literal: true
# This migration comes from decidim_participatory_documents (originally 20230622081831)

class AddDecidimParticipatoryDocumentsBoxPositions < ActiveRecord::Migration[6.0]
  class Document < ApplicationRecord
    self.table_name = :decidim_participatory_documents_documents
    has_many :sections
    has_many :annotations, through: :sections
  end

  class Section < ApplicationRecord
    self.table_name = :decidim_participatory_documents_sections
    belongs_to :document
    has_many :annotations
  end

  class Annotation < ApplicationRecord
    self.table_name = :decidim_participatory_documents_annotations
    belongs_to :section
  end

  # rubocop:disable Rails/SkipsModelValidations:
  def change
    add_column :decidim_participatory_documents_annotations, :position, :integer, null: false, default: 0
    add_index :decidim_participatory_documents_annotations, :position
    add_column :decidim_participatory_documents_sections, :position, :integer, null: false, default: 0
    add_index :decidim_participatory_documents_sections, :position

    Section.find_each do |section|
      section.update_column(:position, section.document.sections.where("id < ?", section.id).count + 1)
    end

    Annotation.find_each do |annotation|
      annotation.update_column(:position, annotation.section.document.annotations.where("decidim_participatory_documents_annotations.id < ?", annotation.id).count + 1)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations:
end
