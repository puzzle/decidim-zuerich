# frozen_string_literal: true

# Override last checked at: 31.07.2023
Decidim::Meetings::JoinMeeting.class_eval do
  private

  def follow_meeting
    return if already_following?

    Decidim::CreateFollow.call(follow_form, user)
  end

  def already_following?
    @meeting.follower_ids.include? @user.id
  end
end
