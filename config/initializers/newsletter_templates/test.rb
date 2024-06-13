Decidim.content_blocks.register(:newsletter_template, :test) do |content_block|
  content_block.cell = "decidim_zuerich/newsletter_templates/test"
  content_block.settings_form_cell = "decidim_zuerich/newsletter_templates/test_settings_form"
  content_block.public_name_key = "decidim_zuerich.newsletter_templates.test.name"

  content_block.images = [
    {
      name: :custom_logo,
      uploader: "Decidim::NewsletterTemplateImageUploader",
      preview: -> { organization.logo }
    },
    {
      name: :main_image,
      uploader: "Decidim::NewsletterTemplateImageUploader",
      preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
    }
  ]

  t = -> (key) { I18n.t("decidim_zuerich.newsletter_templates.test.#{key}") }
  opts = -> (map) { {type: :text, translated: true, preview: "-"}.merge(map) }

  content_block.settings do |settings|
    settings.attribute(:introduction,  opts.(preview: -> { t.("introduction_preview") }))
    settings.attribute(:body,          opts.(preview: -> { t.("body_preview") }        ))
    settings.attribute(:cta_text,      opts.(preview: -> { t.("cta_text_preview") }    ))
    settings.attribute(:cta_url,       opts.(preview: "http://google.com", translated: false ))
    settings.attribute(:color,         opts.(preview: "Farbe", translated: false             ))
  end
end
