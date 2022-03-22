# frozen_string_literal: true

Decidim::Meetings::MeetingsController.class_eval do

  private

  # Order meetings by ascending instead of descending start date
  def meetings
    @meetings ||= paginate(search.results.order(start_time: :asc))
  end

end
