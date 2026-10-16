# frozen_string_literal: true

require 'test_helper'

# Runs Deface's own checks on every Deface override: the template exists, the selector still matches,
# and the matched source still equals the override's `original` (Deface itself only logs that).
# Our overrides must pass and must declare `original`. Overrides from other modules only produce
# warnings (GitHub annotations in CI), so we can report them to the module maintainers.
class DefaceOverridesTest < ActiveSupport::TestCase
  include Deface::TemplateHelper

  # Deface discards the result of validate_original; keep it per override.
  module RecordOriginal
    attr_accessor :original_valid

    def validate_original(match)
      self.original_valid = super
    end
  end
  Deface::Override.prepend(RecordOriginal)

  OVERRIDES = Deface::Override.all.values.flat_map(&:values)
  OURS, OTHERS = OVERRIDES.partition { |override| override.railtie_class == Rails.application.class.name }

  # Other modules' overrides we already reported upstream, to silence their warnings.
  # 'virtual_path: name' => 'where it was reported', e.g.
  # 'layouts/decidim/_head: geo_set_meta_scale' => 'https://github.com/<org>/<module>/issues/<n>'
  IGNORED_MODULE_OVERRIDES = {}.freeze

  OURS.each do |override|
    test "#{override.args[:virtual_path]}: #{override.name}" do
      problems = problems_by_override(override.args[:virtual_path]).fetch(override)
      problems << 'no `original` declared' if problems.empty? && override.original_valid.nil?

      assert_empty problems, "Deface override '#{override.name}' needs review"
    end
  end

  test 'overrides from other modules (warnings only)' do
    with_problems = []
    OTHERS.map { |override| override.args[:virtual_path] }.uniq.each do |virtual_path|
      problems_by_override(virtual_path).each do |override, problems|
        next if problems.empty? || OURS.include?(override)

        key = "#{virtual_path}: #{override.name}"
        with_problems << key
        next if IGNORED_MODULE_OVERRIDES.key?(key)

        annotate("Deface override from #{override.railtie_class}", "#{key}: #{problems.join('; ')}")
      end
    end
    (IGNORED_MODULE_OVERRIDES.keys - with_problems).each do |key|
      annotate('Stale IGNORED_MODULE_OVERRIDES entry', "#{key} has no problems anymore, remove it")
    end
    pass
  end

  private

  # GitHub Actions turns this into a warning annotation on the run. It must start a line,
  # and Minitest's progress dots don't end theirs.
  def annotate(title, message)
    $stdout.puts "\n::warning title=#{title}::#{message}"
  end

  # Applies all overrides of a template and returns { override => [problems] }
  def problems_by_override(virtual_path)
    overrides = Deface::Override.find(virtual_path:).each { |override| override.original_valid = nil }
    load_template_source(virtual_path, false, true)
    overrides.index_with { |override| problems(override) }
  rescue ActionView::MissingTemplate
    overrides.index_with { ["template #{virtual_path} not found"] }
  end

  def problems(override)
    [
      ("selector no longer matches: #{override.selector}" if override.failure),
      ('matched source changed since `original`' if override.original_valid == false)
    ].compact
  end
end
