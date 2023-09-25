# frozen_string_literal: true

# Override last checked at: 31.07.2023
module DecidimZuerich::ParticipatoryProcesses::ParticipatoryProcessHelper
  def step_dates(participatory_process_step)
    dates = [participatory_process_step.start_date, participatory_process_step.end_date].compact

    case dates.count
    when 0 then "Kein Datum angegeben"
    when 1 then localize(dates.first.to_date, format: :default)
    when 2 then "#{localize(dates.first.to_date, format: :default)} - #{localize(dates.second.to_date, format: :default)}"
    else        ""
    end
  end
end