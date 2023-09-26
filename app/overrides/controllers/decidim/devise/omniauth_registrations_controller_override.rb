# frozen_string_literal: true

# Override last checked at: 31.07.2023
Decidim::Devise::OmniauthRegistrationsController.class_eval do
  private

  def user_params_from_oauth_hash
    return nil if oauth_data.empty?

    name = [oauth_data[:info][:first_name], oauth_data[:info][:last_name]].join(' ')

    {
        provider: oauth_data[:provider],
        uid: oauth_data[:uid],
        # Modification for Mein Konto
        name: name,
        # Modification for Mein Konto
        nickname: name.parameterize(separator: '_'),
        oauth_signature: Decidim::OmniauthRegistrationForm.create_signature(oauth_data[:provider], oauth_data[:uid]),
        avatar_url: oauth_data[:info][:image],
        raw_data: oauth_hash
    }
  end
end
