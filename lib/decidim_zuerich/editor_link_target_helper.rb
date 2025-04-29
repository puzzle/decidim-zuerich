# frozen_string_literal: true

module DecidimZuerich
  class EditorLinkTargetHelper

    def initialize(keys)
      @keys = keys
    end

    def self.handle_target_tag(hash, keys)
      new(keys).handle_target_tag(hash)
    end

    def self.handle_query_parameter(hash, keys)
      new(keys).handle_query_parameter(hash)
    end

    def handle_target_tag(hash)
      handle_fields(hash) do |text|
        tag_matches(text)
          .reject { |match| match[3] == '_blank' }
          .reduce(text) do |text, match|
            href, params, target = match.captures.map(&:strip)
            next if target == '_blank'

            divider = href.split('/').last.include?('?') ? '&amp;' : '?'
            new_href = "#{href}#{divider}target=#{target}"

            text.gsub(match[0], %(<a href="#{new_href}" #{params} target="_blank">))
          end
      end
    end

    def handle_query_parameter(hash)
      handle_fields(hash) do |text|
        url_matches(text)
          .reduce(text) do |text, match|
            href, _, target, params = match.captures.map(&:strip)

            text.gsub(match[0], %(<a href="#{href}" #{params} target="#{target}">))
          end
      end
    end

    private

    def url_matches(text)
      matches(text, %r{<a href="([^"]+?)(:?\?|\&amp;)target=([^"]+?)"(.+?)(:?target="_blank")?>})
    end

    def tag_matches(text)
      matches(text, %r{<a href="(.+?)"(.+?)target="(.+?)">})
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

    def handle_fields(hash)
      @keys.reduce(hash) do |hash, key|
        found = try_key(hash, key)
        return hash unless found

        hash[found] = yield(hash.to_h[found])
        hash
      end
    end

    def try_key(hash, key)
      [key, key.to_sym].find { hash[_1].is_a? String }
    rescue StandardError
      nil
    end
  end
end
