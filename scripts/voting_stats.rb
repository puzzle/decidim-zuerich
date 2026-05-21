#!/usr/bin/env ruby
# vim: et:ts=2:sw=2:tw=0:wm=0:fdm=syntax
# frozen_string_literal: true

exec('/usr/bin/env', 'rails', 'runner', $PROGRAM_NAME, *ARGV) unless defined?(Rails)

require 'csv'
require 'cgi'

def divider
  '=' * 80
end

def usage_text
  scriptname = File.basename($PROGRAM_NAME)
  <<~USAGE
    Usage:   #{scriptname} <component id> [type] [file_path]
    Example: #{scriptname} 664            :csv   tmp/voting_stats.csv
  USAGE
end

def exit_msg(status: 0, msg: nil, usage: usage_text)
  puts msg if msg
  puts usage if usage
  exit status
end

# nodoc
class ParameterValidation
  def initialize
    @component_id = component(ARGV[0])
    @output_type = output_type(ARGV[1])
    @output_file = output_file(ARGV[2])
  end

  def self.params
    new.params
  end

  def params
    {
      component_id: @component_id,
      output_type: @output_type,
      output_file: @output_file
    }
  end

  def component(input)
    raise unless Decidim::Component.exists?(input)

    puts 'Component found'
    input
  rescue StandardError
    exit_msg status: 1, msg: 'Component ID not given or not found'
  end

  def output_type(input)
    return :console unless input

    raise unless input.in? %w[console text csv html]

    input.to_sym

  rescue StandardError
    exit_msg status: 1, msg: 'If given, type needs to be one of :console, :text, :csv, or :html'
  end

  def output_file(input)
    file = Pathname.new(input) if input
    file ||=
      begin
        ext = 
          case @output_type
          when :csv then '.csv'
          when :html then '.html'
          else '.txt'
          end

        Pathname.new("tmp/voting_stats#{ext}")
      end

    FileUtils.mkdir_p(file.dirname)
    file
  rescue StandardError => e
    puts "\n"
    pp e
    exit_msg status: 1, msg: "Could not create path to output file: #{input}"
  end
end

# nodoc
class VotingStats
  attr_reader :component_id, :data

  def initialize(data)
    @component_id = data[:component_id]
    @output_type = data[:output_type]
    @output_file = data[:output_file]

    @data = {}
  end

  def self.run
    print_header

    new(ParameterValidation.params).run
  end

  def self.print_header
    puts <<~HEADER
      #{"\n" * 5}
      #{divider}
      Voting Statistics
      #{divider}
      Validation:

    HEADER
  end

  def run
    print_details

    gather_proposal_stats
    gather_global_stats
    gather_voter_density
    gather_frequency_distribution
    gather_daily_timeline
    gather_top_proposals

    save_or_output
  end

  def save_or_output
    run if @data.empty? # Ensure data is loaded

    case @output_type
    when :console
      output_to_console
    when :text
      save_as_text
    when :csv
      save_as_csv
    when :html
      save_as_html
    end

    puts "Saved as '#{@output_file}'" unless @output_type == :console
  end

  def print_details
    puts <<~DETAILS

      #{divider}
      Details:

      component_id: #{component_id}

      #{divider}
      Log:

    DETAILS
  end

  private

  # --- DATA GATHERING ---

  def gather_proposal_stats
    @data[:proposals] = Decidim::Proposals::Proposal
      .where(decidim_component_id: component_id)
      .select(
        "COUNT(*) AS total",
        "COUNT(CASE WHEN withdrawn_at IS NOT NULL THEN 1 END) AS withdrawn",
        "COUNT(CASE WHEN published_at IS NULL THEN 1 END) AS unpublished",
        "COUNT(CASE WHEN published_at IS NOT NULL AND withdrawn_at IS NULL THEN 1 END) AS active"
      ).take
  end

  def gather_global_stats
    @data[:global] = Decidim::Proposals::ProposalVote
      .joins(:proposal)
      .where(decidim_proposals_proposals: { decidim_component_id: component_id })
      .select(
        "COUNT(*) AS total_votes",
        "COUNT(CASE WHEN decidim_proposals_proposals.withdrawn_at IS NOT NULL THEN 1 END) AS withdrawn_votes",
        "COUNT(CASE WHEN decidim_proposals_proposals.published_at IS NULL THEN 1 END) AS unpublished_votes",
        "COUNT(DISTINCT decidim_author_id) AS unique_voters"
      ).take
  end

  def gather_voter_density
    valid_stats = Decidim::Proposals::ProposalVote
      .joins(:proposal)
      .where(decidim_proposals_proposals: { decidim_component_id: component_id, withdrawn_at: nil })
      .where.not(decidim_proposals_proposals: { published_at: nil })
      .select("COUNT(*) AS total_v", "COUNT(DISTINCT decidim_author_id) AS unique_v")
      .take

    total_v = valid_stats.total_v.to_f
    unique_v = valid_stats.unique_v.to_f
    @data[:voter_density] = unique_v > 0 ? (total_v / unique_v).round(2) : 0
  end

  def gather_frequency_distribution
    distribution_sql = <<~SQL
      SELECT vote_count, COUNT(*) AS user_count
      FROM (
        SELECT decidim_author_id, COUNT(*) AS vote_count
        FROM decidim_proposals_proposal_votes
        INNER JOIN decidim_proposals_proposals ON decidim_proposals_proposals.id = decidim_proposals_proposal_votes.decidim_proposal_id
        WHERE decidim_proposals_proposals.decidim_component_id = :comp_id
          AND decidim_proposals_proposals.withdrawn_at IS NULL
          AND decidim_proposals_proposals.published_at IS NOT NULL
        GROUP BY decidim_author_id
      ) subquery
      GROUP BY vote_count ORDER BY vote_count ASC
    SQL

    @data[:distribution] = ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.sanitize_sql_array([distribution_sql, comp_id: component_id])
    ).to_a
  end

  def gather_daily_timeline
    @data[:timeline] = Decidim::Proposals::ProposalVote
      .joins(:proposal)
      .where(decidim_proposals_proposals: { decidim_component_id: component_id, withdrawn_at: nil })
      .where.not(decidim_proposals_proposals: { published_at: nil })
      .group("DATE(decidim_proposals_proposal_votes.created_at)")
      .order("DATE(decidim_proposals_proposal_votes.created_at) ASC")
      .count
  end

  def gather_top_proposals
    raw_top = Decidim::Proposals::ProposalVote
      .joins(:proposal)
      .where(decidim_proposals_proposals: { decidim_component_id: component_id, withdrawn_at: nil })
      .where.not(decidim_proposals_proposals: { published_at: nil })
      .group(:decidim_proposal_id)
      .order("count_all DESC").limit(5).count

    @data[:top_proposals] = raw_top.map do |proposal_id, count|
      proposal = Decidim::Proposals::Proposal.find(proposal_id)
      title_text = proposal.title.is_a?(Hash) ? (proposal.title['en'] || proposal.title.values.first) : proposal.title
      { id: proposal_id, votes: count, title: title_text }
    end
  end

  # --- /DATA GATHERING ---

  # --- FORMAT GENERATORS ---

  def output_to_console
    puts "=== CONSOLE OUTPUT FOR COMPONENT ##{component_id} ==="
    build_csv_matrix.each do |row|
      next if row.empty?
      puts sprintf("%-30s | %-45s | %s", row[0], row[1], row[2])
    end
    nil
  end

  def save_as_csv
    csv = build_csv

    File.write(@output_file, csv)

    csv
  end

  def save_as_text
    text_output = []
    text_output << "================================================================="
    text_output << "  VOTING METRICS REPORT FOR COMPONENT ID: #{component_id}"
    text_output << "  Generated at: #{Time.current if defined?(Time) && Time.respond_to?(:current) || Time.now}"
    text_output << "================================================================="
    text_output << ""

    # Iterate over our established schema array structural template
    build_csv_matrix.each do |row|
      if row.empty?
        text_output << ""
      else
        # Dynamically applies uniform spacing via printf formatting layout rules
        text_output << sprintf("%-30s | %-45s | %s", row[0], row[1], row[2])
      end
    end

    final_text = text_output.join("\n")

    # Write the string content data stream down directly onto file-system storage
    File.write(@output_file, final_text)

    final_text
  end

  def save_as_html
    csv_string = build_csv
    matrix = build_csv_matrix.drop(1)

    html = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>Decidim Component Voting Statistics</title>
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 40px; color: #333; background-color: #f9f9f9; }
          .container { max-width: 900px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
          h2 { color: #1e293b; margin-top: 0; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px; }
          .btn-download { display: inline-block; background-color: #2563eb; color: white; padding: 10px 20px; text-decoration: none; border-radius: 6px; font-weight: bold; margin-bottom: 20px; transition: background 0.2s; }
          .btn-download:hover { background-color: #1d4ed8; }
          table { width: 100%; border-collapse: collapse; margin-top: 10px; }
          th, td { text-align: left; padding: 12px; border-bottom: 1px solid #e2e8f0; }
          th { background-color: #f1f5f9; color: #475569; font-weight: 600; }
          .section-row { background-color: #f8fafc; font-weight: bold; color: #0f172a; }
          .empty-row { height: 15px; background-color: transparent; }
          .empty-row td { border: none; }
        </style>
      </head>
      <body>
        <div class="container">
          <h2>Voting Statistics Report (Component Scope ##{component_id})</h2>

          <a class="btn-download" href="data:text/csv;charset=utf-8,#{CGI.escape(csv_string)}" download="decidim_voting_stats_#{component_id}.csv">
            📥 Download Complete CSV Report
          </a>

          <table>
            <thead>
              <tr>
                <th>Section</th>
                <th>Metric / Item</th>
                <th>Data / Value</th>
              </tr>
            </thead>
            <tbody>
    HTML

    matrix.each do |row|
      if row.empty?
        html << "<tr class='empty-row'><td colspan='3'></td></tr>"
      elsif ["SECTION", "Voter Frequency Breakdown", "Daily Activity Timeline", "Top 5 Winning Proposals"].include?(row[0]) && row[2].nil?
        html << "<tr class='section-row'><td colspan='3'>#{row[0]}</td></tr>"
      else
        html << "<tr><td><strong>#{row[0]}</strong></td><td>#{row[1]}</td><td>#{row[2]}</td></tr>"
      end
    end

    html << <<~HTML
            </tbody>
          </table>
        </div>
      </body>
      </html>
    HTML

    File.write(@output_file, html)
    html
  end

  def build_csv
    CSV.generate(headers: true) do |csv|
      build_csv_matrix.each { |row| csv << row }
    end
  end

  def build_csv_matrix
    [
      ["SECTION", "METRIC / DATA KEY", "VALUE / DETAILS"],
      ["Proposal Profile", "Total Proposals Record Count", @data[:proposals].total],
      ["Proposal Profile", "Withdrawn Proposals", @data[:proposals].withdrawn],
      ["Proposal Profile", "Unpublished Proposals", @data[:proposals].unpublished],
      ["Proposal Profile", "Active / Live Proposals", @data[:proposals].active],
      [],
      ["Global Vote Counts", "Total Raw Votes Cast", @data[:global].total_votes],
      ["Global Vote Counts", "Votes on Withdrawn Items", @data[:global].withdrawn_votes],
      ["Global Vote Counts", "Votes on Unpublished Items", @data[:global].unpublished_votes],
      ["Global Vote Counts", "Total Unique Voters Count", @data[:global].unique_voters],
      [],
      ["Engagement Density", "Average Active Votes Cast per User", @data[:voter_density]],
      []
    ].tap do |matrix|
      matrix << ["Voter Frequency Breakdown", "Vote Count Bucket", "User Count"]
      @data[:distribution].each do |row|
        matrix << ["Voter Frequency Breakdown", "Users who voted exactly #{row['vote_count']} time(s)", row['user_count']]
      end

      matrix << []
      matrix << ["Daily Activity Timeline", "Date", "Votes Cast"]
      @data[:timeline].each do |date, count|
        matrix << ["Daily Activity Timeline", date.to_s, count]
      end

      matrix << []
      matrix << ["Top 5 Winning Proposals", "Rank / Proposal ID", "Proposal Title", "Total Votes"]
      @data[:top_proposals].each_with_index do |prop, idx|
        matrix << ["Top 5 Winning Proposals", "Rank ##{idx+1} (ID: #{prop[:id]})", prop[:title], prop[:votes]]
      end
    end
  end


  # --- /FORMAT GENERATORS ---

end

# data = ParameterValidation.new.params
VotingStats.run
