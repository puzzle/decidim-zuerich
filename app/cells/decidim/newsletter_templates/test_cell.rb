require "cell/partial"

module Decidim
  module NewsletterTemplates
    class TestCell < Decidim::NewsletterTemplates::BaseCell
      def show
        render :show
      end

      def introduction
        parse_interpolations(uninterpolated_introduction, recipient_user, newsletter.id)
      end

      def uninterpolated_introduction
        translated_attribute(model.settings.introduction)
      end

      def body
        parse_interpolations(uninterpolated_body, recipient_user, newsletter.id)
      end

      def fields
        %i[boolean integer string text].map do |type|
          field = model.settings.send("field_#{type}")
          translated = translated_attribute(field)
          parse_interpolations(translated, recipient_user, newsletter.id)
        end
      end

      def uninterpolated_body
        translated_attribute(model.settings.body)
      end

      def has_cta?
        cta_text.present? && cta_url.present?
      end

      def cta_text
        parse_interpolations(
          translated_attribute(model.settings.cta_text),
          recipient_user,
          newsletter.id
        )
      end

      def cta_url
        translated_attribute(model.settings.cta_url)
      end

      def has_main_image?
        newsletter.template.images_container.main_image.attached?
      end

      def main_image
        image_tag main_image_url
      end

      def main_image_url
        newsletter.template.images_container.attached_uploader(:main_image).url(host: organization.host)
      end

      def organization_primary_color
        organization.colors["primary"]
      end
    end
  end
end

