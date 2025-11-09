#!/usr/bin/env ruby
# vim: et:ts=2:sw=2:tw=0:wm=0:fdm=expr
# frozen_string_literal: true

exec('/usr/bin/env', 'rails', 'runner', $PROGRAM_NAME, *ARGV) unless defined?(Rails)

def divider
  '=' * 80
end

def usage_text
  scriptname = File.basename($PROGRAM_NAME)
  <<~USAGE
    Usage:   #{scriptname} <org id> <model>                      <id> <field> <locale> [key_pattern]
    Example: #{scriptname} 1        Decidim::Proposals::Proposal 1    body    de       nettonull
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
    @organization = organization(ARGV[0])
    @model = model(ARGV[1])
    @entry = entry(ARGV[2])
    @field = field(ARGV[3])
    @locale = locale(ARGV[4])
    @key_pattern = key_pattern(ARGV[5])
  end

  def self.params
    new.params
  end

  def params
    {
      organization: @organization,
      model: @model,
      entry: @entry,
      field: @field,
      locale: @locale,
      key_pattern: @key_pattern
    }
  end

  def organization(input)
    org = Decidim::Organization.find(input)
    raise unless org

    puts 'Organization found'
    org
  rescue StandardError
    exit_msg status: 1, msg: 'Organization ID not given or not found'
  end

  def model(input)
    model = input.constantize

    raise unless defined?(model)

    puts 'Model found'
    model
  rescue StandardError
    exit_msg status: 1, msg: 'Model not given or not found'
  end

  def entry(input)
    entry = @model.find(input)

    raise unless entry

    puts 'Entry found'
    entry
  rescue StandardError
    exit_msg status: 1, msg: "ID not given or '#{@model.try(:name)}' with ID not found"
  end

  def field(input)
    raise unless @entry.attributes.keys.include? input

    puts 'Field found'
    input
  rescue StandardError
    exit_msg status: 1, msg: 'Field not given or field not found on entry'
  end

  def locale(input)
    valid_locales = Rails.application.config.i18n.available_locales
    raise unless valid_locales.include?(input)

    input
  rescue StandardError
    exit_msg status: 1, msg: "Locale not given or not one of #{valid_locales.join(', ')}"
  end

  def key_pattern(input = nil)
    Regexp.new(input)
  rescue StandardError
    nil
  end
end

# nodoc
class TranslationReplacer
  def initialize(data)
    @organization = data[:organization]
    @model = data[:model]
    @entry = data[:entry]
    @field = data[:field]
    @locale = data[:locale]
    @key_pattern = data[:key_pattern]

    @text = @entry.attributes[@field][@locale]
    @keys = []
    @filtered_keys = []
    @new_text = ''
  end

  def self.run
    print_header
    tmp = new(ParameterValidation.params)
    tmp.run
  end

  def self.print_header
    puts <<~HEADER
      #{"\n" * 5}
      #{divider}
      Translation Replacer
      #{divider}
      Validation:

    HEADER
  end

  def run
    print_details
    @keys = find_keys
    @filtered_keys = filter_keys
    @new_text = translate_text
    save
  end

  def print_details
    puts <<~DETAILS

      #{divider}
      Details:

      organization: #{@organization}
      model: #{@model}
      entry: #{@entry}
      field: #{@locale}
      locale: #{@locale}
      key_pattern: #{@key_pattern.inspect}

      #{divider}
      Log:

    DETAILS
  end

  def find_keys
    pattern = /(\w+(?:\.\w+)+)/
    keys = @text.scan(pattern).flatten

    exit_msg msg: 'No Keys to translate', usage: false if keys.none?

    puts "#{keys.count} key(s) found in text"
    keys
  end

  def filter_keys
    return @keys if @key_pattern.blank?

    keys = @keys.grep(@key_pattern)

    if keys.none?
      exit_msg msg: "No keys left after filtering by #{@key_pattern.inspect}\nKeys: #{@keys.inspect}",
               usage: false
    end

    puts "#{keys.count} key(s) found after filtering"

    keys
  end

  def translate_text
    @filtered_keys.inject(@text) do |memo, key|
      translation = find_tc_translation(key)
      translation ||= find_locale_translation(key)

      raise unless translation

      puts "Translation found for: '#{key}'"
      memo.gsub(key, translation)
    rescue StandardError
      puts "Translation not found for: '#{key}'"
      next memo
    end
  end

  def save
    @entry[@field][@locale] = @new_text

    exit_msg msg: 'There were no applicable changes! Text is still the same', usage: false unless @entry.changed?

    @entry.save!

    puts <<~CHANGED

      #{divider}

      Old Text:
      #{@text}

      #{divider}

      New Text:
      #{@new_text}

      #{divider}

      Done!
    CHANGED
  end

  private

  def find_tc_translation(key) # rubocop:disable Metrics/MethodLength
    Decidim::TermCustomizer::Translation
      .joins(translation_set: :constraints)
      .where(
        locale: @locale,
        key:,
        translation_set: {
          decidim_term_customizer_constraints: {
            decidim_organization_id: @organization.id
          }
        }
      )
      .pick(:value)
  end

  def find_locale_translation(key)
    I18n.t(key, locale: @locale)
  rescue StandardError
    nil
  end
end

# data = ParameterValidation.new.params
TranslationReplacer.run

exit 0

def commented_out # rubocop:disable Lint/UnreachableCode
  # Find translation keys
  # pattern = /(\w+(?:\.\w+)+)/
  # keys = text.scan(pattern).flatten
  #
  # if keys.any?
  #   puts "#{keys.count} key(s) found in text"
  # else
  #   puts 'No Keys to translate'
  #   exit 0
  # end
  #
  # keys = keys.grep(data[:key_pattern]) if data[:key_pattern].present?
  #
  # if keys.any?
  #   puts "#{keys.count} key(s) found after filtering"
  # else
  #   puts "No keys left after filtering by #{data[:key_pattern].inspect}"
  #   exit 0
  # end
  #
  # new_text =
  #   keys.inject(text) do |tmp_text, key|
  #     field = data[:field]
  #     locale = data[:locale]
  #
  #     translation =
  #       Decidim::TermCustomizer::Translation
  #       .joins(translation_set: :constraints)
  #       .where(locale:, key:)
  #       .where(
  #         translation_set: {
  #           decidim_term_customizer_constraints: {
  #             decidim_organization_id: data[:org].id
  #           }
  #         }
  #       )
  #       .pick(:value)
  #
  #     translation ||=
  #       begin
  #         I18n.t(key, locale:)
  #       rescue StandardError
  #         nil
  #       end
  #
  #     return puts "Translation not found for: '#{key}'" unless translation
  #
  #     puts "Translation found for: '#{key}'"
  #     tmp_text.gsub(key, translation)
  #   end
  #
  # entry[field][locale] = new_text
  #
  # if entry.changed?
  #   puts 'Old Text:'
  #   puts text
  #   puts
  #   puts 'New Text:'
  #   puts new_text
  #
  #   entry.save!
  #   puts 'Done!'
  # else
  #   puts 'Text was not changed'
  # end
  #
  # exit 0
  # def usage
  #   puts <<~USAGE
  #     Usage:
  #       #{File.basename($PROGRAM_NAME)} <org id> <model> <id> <field> <locale> [key_pattern]
  #     Example:
  #       #{File.basename($PROGRAM_NAME)} 1 Decidim::Proposals::Proposal 1 body de nettonull
  #   USAGE
  # end
  #
  # def exit_msg(status = 0)
  #   usage
  #   exit status
  # end
  #
  # org =
  #   if (org = ARGV[0] && Decidim::Organization.find(ARGV[0]))
  #     puts 'Organization found'
  #     org
  #   else
  #     puts 'Organization ID not given or not found'
  #     exit_msg 1
  #   end
  #
  # model =
  #   if ARGV[1] && defined?(ARGV[1].constantize)
  #     puts 'Model found'
  #     ARGV[1].constantize
  #   else
  #     puts 'Model not given or not found'
  #     exit_msg 1
  #   end
  #
  # entry =
  #   if (tmp = ARGV[2] && model.find(ARGV[2]))
  #     puts 'Entry found'
  #     tmp
  #   else
  #     puts "ID not given or #{model.name} with ID not found"
  #     exit_msg 1
  #   end
  #
  # field =
  #   if entry.attributes.keys.include? ARGV[3]
  #     puts 'Field found'
  #     ARGV[3]
  #   else
  #     puts 'Field not given or field not found on entry'
  #     exit_msg 1
  #   end
  #
  # valid_locales = Rails.application.config.i18n.available_locales
  # locale =
  #   if ARGV[4] && valid_locales.include?(ARGV[4])
  #     ARGV[4]
  #   else
  #     puts "Locale not given or not one of #{valid_locales.join(', ')}"
  #     exit_msg 1
  #   end
  #
  # text = entry.attributes[field][locale]
  #
  # key_pattern = ARGV[5] && Regexp.new(ARGV[5])
  #
  #
  # data = { org:, model:, entry:, field:, locale:, text:, key_pattern: }
  #
  #
  # {{{
  # puts
  # puts
  # puts
  # puts 'Which model do you want to edit?'
  # models =
  #   ActiveRecord::Base
  #   .descendants
  #   .select do
  #     pattern = /#{model_input}/i
  #
  #     _1.model_name.human =~ pattern ||
  #     _1.model_name.singular_route_key =~ pattern
  #   end
  #
  # model =
  #   if models.none?
  #     puts 'No model found, exiting'
  #     exit 1
  #   elsif models.one?
  #     models.first
  #   else
  #     choice = nil
  #     loop do
  #       puts 'Which model do you want?'
  #       models.each_with_index do |model, idx|
  #         puts "#{idx}: #{model}"
  #       end
  #       puts 'q: Quit'
  #
  #       input = gets.strip
  #       choice = models[input.to_i].presence if input =~ /\d+/
  #       exit 1 if input == 'q'
  #       break if models
  #
  #       puts 'Not a valid input, try again'
  #     end
  #
  #     choice
  #   end
  #
  # puts "Using #{model}"
  #
  # puts 'Which id?'
  # id = gets.strip.to_i
  #
  # if (entry = model.find(id))
  #   puts 'Entry found, which attribute do you want to edit?'
  #
  #   input = gets.strip
  #
  #   loop do
  #     keys = entry.attributes.select do |key|
  #       key =~ input
  #     end
  #
  #     break if
  #   end
  # else
  #   puts 'Entry not found, exiting'
  #   exit 1
  # end
  # }}}
end
