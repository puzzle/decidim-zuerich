# frozen_string_literal: true

module ApplicationHelper
  def number_to_currency(number, options = {})
    defaults = {
      locale: :de,
      unit: Decidim.currency_unit,
      separator: ',',
      delimiter: '\'',
      format: '%u %n'
    }
    super number, defaults.merge(options)
  end

  def assembly_or_space(space)
    safe_join([
                  link_to(translated_attribute(space.title), Decidim::ResourceLocatorPresenter.new(space).path, class: "card__link text-ellipsis"),
                  parantheses(assembly_for_space(space))
              ].compact)
  end

  private

  def parantheses(html)
    return nil unless html
    content_tag :span, { style: 'margin-left: 0.2rem' } do
      ['(', html, ')'].join('')
    end
  end

  def assembly_for_space(space)
    link = Decidim::ParticipatorySpaceLink.find_by(to: space,
                                                   name: 'included_participatory_processes',
                                                   from_type: 'Decidim::Assembly')
    return nil unless link

    assembly = link.from
    link_to(translated_attribute(assembly.title), Decidim::ResourceLocatorPresenter.new(assembly).path, class: 'card__link text-ellipsis')
  end
end
