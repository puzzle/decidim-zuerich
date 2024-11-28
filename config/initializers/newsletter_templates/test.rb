Decidim.content_blocks.register(:newsletter_template, :test) do |content_block|
  content_block.cell = "decidim_zuerich/newsletter_templates/test"
  content_block.settings_form_cell = "decidim_zuerich/newsletter_templates/test_settings_form"
  content_block.public_name_key = "decidim_zuerich.newsletter_templates.test.name"

  content_block.images = [
    {
      name: :main_image,
      uploader: "Decidim::NewsletterTemplateImageUploader",
      preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
    }
  ]

  t = -> (key) { I18n.t("decidim_zuerich.newsletter_templates.test.#{key}") }
  opts = -> (map) { {type: :text, translated: true, preview: "-"}.merge(map) }

  content_block.settings do |settings|
    settings.attribute(:introduction, opts.(preview: -> { t.("introduction_preview") }))
    settings.attribute(:body,         opts.(preview: -> { t.("body_preview") }        ))
    settings.attribute(:cta_text,     opts.(preview: -> { t.("cta_text_preview") }    ))
    settings.attribute(:cta_url,      opts.(preview: "http://google.com"              ))
    settings.attribute(:field_boolean, opts.(type: :boolean, preview: "Wahrheit"       ))
    settings.attribute(:field_integer, opts.(type: :integer, preview: "Zahl"           ))
    settings.attribute(:field_string,  opts.(type: :string,  preview: "String"         ))
    settings.attribute(:field_text,    opts.(type: :text,    preview: "Text"           ))
    settings.attribute(:field_array,   opts.(type: :array,   preview: "Array"          ))
    settings.attribute(:field_enum,    opts.(type: :enum,    preview: "Enum"           ))
    settings.attribute(:field_select,  opts.(type: :select,  preview: "Select"         ))
    settings.attribute(:field_scope,   opts.(type: :scope,   preview: "Scope"          ))
    settings.attribute(:field_time,    opts.(type: :time,    preview: "Zeit"           ))
  end
end
