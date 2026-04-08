# Adds a missing rake task for revoking SMS verifications.
# Decidim is supposed to add this task in decidim-verifications/lib/tasks/revoke.rake
# But this file is evaluated before the initializers have a chance to configure the
# Decidim.sms_gateway_service (in our decidim initializer) and register the sms
# verification workflow (in decidim-verifications/lib/decidim/verifications/sms/engine.rb)
#
# See https://github.com/decidim/decidim/issues/16546 where this bug is reported and tracked.

namespace :decidim do
  namespace :verifications do
    namespace :revoke do
      desc "Revokes authorizations for the sms workflow"
      task :sms, [] => :environment do
        logger.info("=== Revoking authorizations for the sms workflow")
        Decidim::Authorization.where(name: :sms).destroy_all
        logger.info("===== Done")
      end
    end
  end
end
