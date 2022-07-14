# frozen_string_literal: true

# Prolong session expiration time from the decidim default of 30 minutes to 2 hours.
# This is a remedy for the exceptionally long surveys for elderly people that the
# Mitwirken platform offers.
Devise.setup do |config|

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again. Default is 30 minutes.
  config.timeout_in = 2.hours

end
