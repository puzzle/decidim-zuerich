require "cell/partial"

module Decidim
  module NewsletterTemplates
    class MultiTenantCell < Decidim::NewsletterTemplates::BaseCell
      def show
        render :show
      end

      def banner_color_top
        model.settings.banner_color_top
      end

      def banner_color_bottom
        model.settings.banner_color_bottom
      end

      def has_logo?
        preview? || newsletter.template.images_container.logo.attached?
      end

      def logo
        image_tag logo_url
      end

      def logo_url
        return 'https://placehold.co/300x100' if preview?

        newsletter.template.images_container.attached_uploader(:logo).url(host: organization.host)
      end

      def introduction
        parse_interpolations(uninterpolated_introduction, recipient_user, newsletter.id)
      end

      def uninterpolated_introduction
        translated_attribute(model.settings.introduction)
      end

      def has_main_image?
        preview? || newsletter.template.images_container.main_image.attached?
      end

      def main_image
        image_tag main_image_url
      end

      def main_image_url
        return 'https://placehold.co/200x200' if preview?

        newsletter.template.images_container.attached_uploader(:main_image).url(host: organization.host)
      end

      def body
        parse_interpolations(uninterpolated_body, recipient_user, newsletter.id)
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
        model.settings.cta_url
      end

      def conclusion
        parse_interpolations(uninterpolated_conclusion, recipient_user, newsletter.id)
      end

      def uninterpolated_conclusion
        translated_attribute(model.settings.conclusion)
      end

      def preview?
        controller.instance_variable_get("@preview")
      end
    end
  end
end

