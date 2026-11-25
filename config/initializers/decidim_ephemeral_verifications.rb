# frozen_string_literal: true

# Phone numbers typed without a country code ("079 123 45 67") are Swiss.
# The module normalises every spelling to E.164 before hashing it, so this is
# what makes the national spelling count as the same phone as "+41 79 ...".
Decidim::EphemeralVerifications::Sms.default_country = 'CH'
