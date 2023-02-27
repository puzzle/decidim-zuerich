# frozen_string_literal: true

class DecidimZuerich::MicrosoftTranslator
  attr_reader :text, :source_locale, :target_locale, :resource, :field_name

  def initialize(resource, field_name, text, target_locale, source_locale)
    @resource = resource
    @field_name = field_name
    @text = text
    @target_locale = target_locale
    @source_locale = source_locale
  end

  def translate
    translated_text = request_translation

    Decidim::MachineTranslationSaveJob.perform_later(
      resource,
      field_name,
      target_locale,
      translated_text
    )
  end

  private

  def request_translation
    endpoint = Rails.application.secrets.translator[:endpoint_url]
    secret_key = Rails.application.secrets.translator[:secret_key]
    path = '/translator/text/v3.0/translate?api-version=3.0'
    params = "&from=#{source_locale}&to=#{target_locale}"
    uri = URI(endpoint + path + params)
    content = [{ text: text }].to_json

    request = Net::HTTP::Post.new(uri)
    request['Content-type'] = 'application/json'
    request['Content-length'] = content.length
    request['Ocp-Apim-Subscription-Key'] = secret_key
    request['X-ClientTraceId'] = SecureRandom.uuid
    request.body = content

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    result = response.body.force_encoding("utf-8")
    json = JSON.parse(result)
    json.dig(0, 'translations', 0, 'text')
  end
end
