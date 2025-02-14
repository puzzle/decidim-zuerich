Decidim.content_blocks.register(:newsletter_template, :multi_tenant) do |content_block|
  content_block.cell = "decidim/newsletter_templates/multi_tenant"
  content_block.settings_form_cell = "decidim/newsletter_templates/multi_tenant_settings_form"
  content_block.public_name_key = "decidim.newsletter_templates.multi_tenant.name"

  t = -> (key) { I18n.t("decidim.newsletter_templates.multi_tenant.#{key}") }
  uploader = "Decidim::NewsletterTemplateImageUploader"

  content_block.images = [
    { name: :logo, uploader: uploader, preview: -> { "https://placehold.co/300x100" } },
    { name: :main_image, uploader: uploader, preview: -> { "https://placehold.co/200x200" } }
  ]

  content_block.settings do |settings|
    settings.attribute(
      :banner_color_top,
      type: :string,
      preview: '#ff0000'
    )
    settings.attribute(
      :banner_color_bottom,
      type: :string,
      preview: '#00ff00'
    )
    settings.attribute(
      :introduction,
      type: :text,
      translated: true,
      preview: -> { t.("introduction_preview") }
    )
    settings.attribute(
      :body,
      type: :text,
      translated: true,
      preview: -> { t.("body_preview") }
    )
    settings.attribute(
      :cta_text,
      type: :string,
      translated: true,
      preview: -> { t.("cta_text_preview") }
    )
    settings.attribute(
      :cta_url,
      type: :string,
      translated: false,
      preview: "http://google.com"
    )
    settings.attribute(
      :conclusion,
      type: :text,
      translated: true,
      preview: -> { t.("conclusion_preview") }
    )
  end
end
