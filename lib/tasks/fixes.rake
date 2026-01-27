task 'decidim_zuerich:mailers:notifications_digest_daily' => :environment do
  time = Time.now.utc
  notification_users = Decidim::Notification.daily(time).select(:decidim_user_id)
  target_users = Decidim::User.where(id: notification_users,
                                     notifications_sending_frequency: :daily)

  target_users.find_each do |user|
    Decidim::EmailNotificationsDigestGeneratorJob.perform_later(user.id, :daily, time:)
  end
end

task 'decidim_zuerich:mailers:notifications_digest_weekly' => :environment do
  time = Time.now.utc
  notification_users = Decidim::Notification.weekly(time).select(:decidim_user_id)
  target_users = Decidim::User.where(id: notification_users,
                                     notifications_sending_frequency: :weekly)

  target_users.find_each do |user|
    Decidim::EmailNotificationsDigestGeneratorJob.perform_later(user.id, :weekly, time:)
  end
end
