# frozen_string_literal: true

# Override last checked at: 04.04.2025
Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessesController.class_eval do
  def edit
    enforce_permission_to :update, :process, process: current_participatory_process

    @form = form(Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm).from_model(current_participatory_process)

    @form[:description_de] = reset_url_target(@form[:description_de])
    @form[:description_en] = reset_url_target(@form[:description_en])

    render layout: "decidim/admin/participatory_process"
  end

  private

  def participatory_process_params
    ppp = { id: params[:slug] }.merge(params[:participatory_process].to_unsafe_h)

    ppp['description_de'] = apply_url_target(ppp['description_de'])
    ppp['description_en'] = apply_url_target(ppp['description_en'])

    ppp
  end

  def apply_url_target(text)
    pattern = %r{<a href="([^"]+?)(:?\?|\&amp;)target=([^"]+?)"(.+?)(:?target="_blank")?>}
    matches = matches(text, pattern)

    matches
      .reduce(text) do |text, match|
        href, _, target, params = match.captures.map(&:strip)

        text.gsub(match[0], %(<a href="#{href}" #{params} target="#{target}">))
      end
  end

  def reset_url_target(text)
    pattern = %r{<a href="(.+?)"(.+?)target="(.+?)">}
    matches = matches(text, pattern)

    matches
      .reject { |match| match[3] == '_blank' }
      .reduce(text) do |text, match|
        href, params, target = match.captures.map(&:strip)
        next if target == '_blank'

        divider = href.split('/').last.include?('?') ? '&amp;' : '?'
        new_href = "#{href}#{divider}target=#{target}"

        text.gsub(match[0], %(<a href="#{new_href}" #{params} target="_blank">))
      end
  end

  def matches(str, regexp)
    start_at = 0
    matches  = []
    while(match = str.match(regexp, start_at))
      matches.push(match)
      start_at = match.end(0)
    end
    matches
  end
end
