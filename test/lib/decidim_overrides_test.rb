# frozen_string_literal: true

require 'test_helper'
require 'digest'
require 'prism'

# Our app code that replaces or patches Decidim code, with MD5s of the Decidim code it depends on.
# A failure means that Decidim code changed, usually with a Decidim update: re-test our file, then
# update the MD5 (the failure shows the new value). Deface overrides: see deface_overrides_test.rb.
#
# Every app file replacing a Decidim file (same path) and every app/overrides/**/*_override.rb needs
# an entry covering what it touches: the replaced file, or for Ruby overrides each method it defines,
# its class, or the file defining its class.
#
# our file => {
#   description: what our file changes and why (required),
#   tickets:     issue URLs where it's tracked, in this or another project's repo (optional),
#   targets: { the Decidim code it depends on, only this is checked (required):
#     files:   { 'path in a Decidim gem' => MD5 }, prefixed with the gem name if several gems have it
#              ('config/locales/en.yml' vs. 'decidim-core/config/locales/en.yml'),
#     classes: { 'Decidim::Class' => MD5 of the class body },
#     methods: { 'Decidim::Class#method' => MD5 of the method }
#   }
# }

DECIDIM_OVERRIDE_CHECKS = {
  'app/packs/src/decidim/decidim_application.js' => {
    description: 'Scrolls to the start of the new survey section on Continue/Back',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/636'],
    targets: {
      files: {
        'app/cells/decidim/forms/step_navigation/show.erb' => '35ab80211587992fd02051292145c299',
        'app/views/decidim/forms/questionnaires/_questionnaire.html.erb' => '6621c8c32547c17f21cb6ee0b9e19eba',
        'app/packs/src/decidim/controllers/toggle/controller.js' => 'ca0f2c3c2d08562f1d2355fc92266bea'
      }
    }
  },
  'app/packs/stylesheets/decidim/decidim_application.scss' => {
    description: 'Keeps the survey section start clear of the mobile sticky header',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/636'],
    targets: {
      files: {
        'app/views/decidim/forms/questionnaires/_questionnaire.html.erb' => '6621c8c32547c17f21cb6ee0b9e19eba',
        'app/packs/src/decidim/controllers/sticky_header/controller.js' => '81d609d25b8d44d6c08eb54ce0fc9931',
        'app/packs/stylesheets/decidim/_header.scss' => 'f6fae306f8dacb6c6fe9ad831756570b'
      }
    }
  },
  'app/views/decidim/admin/scope_types/index.html.erb' => {
    description: 'Empties the admin scope types page ("Temporally remove for testing", 2025-09); still pending',
    targets: {
      files: {
        'app/views/decidim/admin/scope_types/index.html.erb' => 'ab51f2c75e21229b34158f72f0644517'
      }
    }
  },
  'app/views/decidim/system/organizations/_smtp_settings.html.erb' => {
    description: 'Adds the tenant type select (Mitwirken / Meinquartier) to the system organization form',
    targets: {
      files: {
        'app/views/decidim/system/organizations/_smtp_settings.html.erb' => 'c787df3e25fd163446aafd9c7b932a96'
      }
    }
  },
  'app/packs/src/decidim/geocoding/provider/photon.js' => {
    description: 'Swaps Photon coordinates: Photon returns longitude first, Decidim expects latitude first',
    targets: {
      files: {
        'app/packs/src/decidim/geocoding/provider/photon.js' => '7a32057a493be733d0224bcb30016ed0'
      }
    }
  },
  'app/views/devise/mailer/confirmation_instructions.html.erb' => {
    description: 'Devise mail copied into the app so TermCustomizer can change its texts',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/319'],
    targets: {
      files: {
        'app/views/devise/mailer/confirmation_instructions.html.erb' => '17892d385f06877380f2f32cdd3f0635'
      }
    }
  },
  'app/views/devise/mailer/invitation_instructions.html.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invitation_instructions.html.erb' => 'b91d1abb95c177c7a1e589d3b219aed9'
      }
    }
  },
  'app/views/devise/mailer/invitation_instructions.text.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invitation_instructions.text.erb' => '9cead0ff427148d0b61717d471488116'
      }
    }
  },
  'app/views/devise/mailer/invite_admin.html.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invite_admin.html.erb' => '4b84f2d411ed8da3d31471e869161536'
      }
    }
  },
  'app/views/devise/mailer/invite_admin.text.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invite_admin.text.erb' => '3ae01561d9f2754604bb5fd39d32a50a'
      }
    }
  },
  'app/views/devise/mailer/invite_collaborator.html.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invite_collaborator.html.erb' => '4b84f2d411ed8da3d31471e869161536'
      }
    }
  },
  'app/views/devise/mailer/invite_collaborator.text.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invite_collaborator.text.erb' => '3ae01561d9f2754604bb5fd39d32a50a'
      }
    }
  },
  'app/views/devise/mailer/invite_private_user.html.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invite_private_user.html.erb' => 'f978eddb05fa55af2c33ce78c964a2bb'
      }
    }
  },
  'app/views/devise/mailer/invite_private_user.text.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/invite_private_user.text.erb' => 'c8de91d2c1e9ddb69c2f8e3935aa41a5'
      }
    }
  },
  'app/views/devise/mailer/organization_admin_invitation_instructions.html.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/organization_admin_invitation_instructions.html.erb' =>
          '33afd7cdd7b4d78f7d76964cd6b2b2a2'
      }
    }
  },
  'app/views/devise/mailer/organization_admin_invitation_instructions.text.erb' => {
    description: 'Devise mail for TermCustomizer texts, with the organization name fixed',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/319',
      'https://github.com/stadtluzern/decidim-ocl/issues/333'
    ],
    targets: {
      files: {
        'app/views/devise/mailer/organization_admin_invitation_instructions.text.erb' =>
          '49615576f513b7632fb70a15d9458faa'
      }
    }
  },
  'app/views/devise/mailer/password_change.html.erb' => {
    description: 'Devise mail copied into the app so TermCustomizer can change its texts',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/319'],
    targets: {
      files: {
        'app/views/devise/mailer/password_change.html.erb' => '1c339299077b3764ca96bc8320d78175'
      }
    }
  },
  'app/views/devise/mailer/reset_password_instructions.html.erb' => {
    description: 'Devise mail copied into the app so TermCustomizer can change its texts',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/319'],
    targets: {
      files: {
        'app/views/devise/mailer/reset_password_instructions.html.erb' => '40e2a215f87b399286f9039be73af22c'
      }
    }
  },
  'app/views/devise/mailer/unlock_instructions.html.erb' => {
    description: 'Devise mail copied into the app so TermCustomizer can change its texts',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/319'],
    targets: {
      files: {
        'app/views/devise/mailer/unlock_instructions.html.erb' => 'f3ff9db265717af4079a62180652ce93'
      }
    }
  },
  'app/views/layouts/decidim/_mailer_logo.html.erb' => {
    description: 'Falls back to another logo URL when variant_url fails, because S3 is on a different domain',
    targets: {
      files: {
        'app/views/layouts/decidim/_mailer_logo.html.erb' => '8c6978d195e708d7d85ccfe63b710fa8'
      }
    }
  },
  'app/overrides/cells/decidim/translation_bar_cell_override.rb' => {
    description: 'Shows the translation banner only outside the organization default locale',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/331'],
    targets: {
      methods: { 'Decidim::TranslationBarCell#renderable?' => '099e3c47938bde03a5635b7fadb41dcd' }
    }
  },
  'app/overrides/controllers/decidim/admin/officializations_controller_override.rb' => {
    description: 'Orders the admin participants list so pagination is stable',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/160'],
    targets: {
      methods: { 'Decidim::Admin::OfficializationsController#collection' => '6913fcf3ee000bece4e3e05ba09d53d0' }
    }
  },
  'app/overrides/controllers/decidim/proposals/proposals_controller_override.rb' => {
    description: 'Uses the component setting for the default proposals view mode (grid/list)',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/590'],
    targets: {
      methods: { 'Decidim::Proposals::ProposalsController#default_view_mode' => 'd7bc75715928f69333b07b0b974cbb0c' }
    }
  },
  'app/overrides/forms/decidim/system/update_organization_form_override.rb' => {
    description: 'Adds the tenant_type attribute to the system organization form',
    targets: {
      classes: { 'Decidim::System::UpdateOrganizationForm' => '2057b0e412c3b5cc1bca582b8ea2ed06' }
    }
  },
  'app/overrides/mailers/application_mailer_override.rb' => {
    description: 'Sets reply-to per tenant type (decidim_zuerich.reply_to translations)',
    tickets: [
      'https://github.com/puzzle/decidim-zuerich/issues/287',
      'https://github.com/puzzle/decidim-zuerich/issues/529'
    ],
    targets: {
      methods: { 'Decidim::ApplicationMailer#set_from' => 'adbeafe13e864733c3252b1616a6a161' }
    }
  },
  'app/models/decidim_zuerich/geo/update_geo_index.rb' => {
    description: 'Removes destroyed records from the Geo index instead of crashing after commit',
    tickets: ['https://github.com/puzzle/decidim-zuerich/issues/641'],
    targets: {
      files: { 'decidim-decidim_geo/lib/decidim/geo/update_geo_index.rb' => 'a6c70fd9c17929c59a3744f01fd0cbae' }
    }
  }
}.freeze

class DecidimOverridesTest < ActiveSupport::TestCase
  ENTRY_KEYS = %i[description tickets targets].freeze
  TARGET_KINDS = %i[files classes methods].freeze

  # Decidim files that exist to be replaced by the app; replacing them needs no entry
  EXTENSION_POINTS = %w[
    app/views/layouts/decidim/_head_extra.html.erb
    app/packs/src/decidim/decidim_application.js
    app/packs/stylesheets/decidim/decidim_application.scss
  ].freeze

  DECIDIM_GEM_DIRS = Gem.loaded_specs.values
                        .select { |spec| spec.name.start_with?('decidim') }
                        .to_h { |spec| [spec.name, spec.gem_dir] }

  def self.app_files(pattern)
    Rails.root.glob(pattern).map { |path| path.relative_path_from(Rails.root).to_s }
  end

  REPLACED = app_files('app/{views,cells,packs}/**/*.*').select do |path|
    DECIDIM_GEM_DIRS.values.any? { |dir| File.file?(File.join(dir, path)) }
  end - EXTENSION_POINTS
  RUBY_OVERRIDES = app_files('app/overrides/**/*_override.rb')

  (DECIDIM_OVERRIDE_CHECKS.keys | REPLACED | RUBY_OVERRIDES).sort.each do |file|
    test file do
      checks = DECIDIM_OVERRIDE_CHECKS.fetch(file) { flunk "#{file} has no entry in DECIDIM_OVERRIDE_CHECKS" }
      assert_valid_entry(file, checks)
      targets = checks[:targets]
      assert_empty uncovered(file, targets),
                   "Touches Decidim code its DECIDIM_OVERRIDE_CHECKS entry doesn't list:#{context(file, checks)}"

      actual = targets.to_h { |kind, md5s| [kind, md5s.to_h { |name, _| [name, md5_of(kind, name)] }] }
      assert_empty actual.values.flat_map { |md5s| md5s.select { |_, md5| md5.nil? }.keys },
                   "No longer in Decidim, re-check:#{context(file, checks)}"
      assert_equal targets, actual, "Decidim code changed, re-test and update the MD5s:#{context(file, checks)}"
    end
  end

  private

  def assert_valid_entry(file, checks)
    assert checks[:description].present?, "#{file} has no description in DECIDIM_OVERRIDE_CHECKS"
    assert checks[:targets].present?, "#{file} has no targets in DECIDIM_OVERRIDE_CHECKS"
    assert_empty checks.keys - ENTRY_KEYS, "#{file}: unknown keys in its DECIDIM_OVERRIDE_CHECKS entry"
    assert_empty checks[:targets].keys - TARGET_KINDS, "#{file}: unknown keys in its DECIDIM_OVERRIDE_CHECKS targets"
  end

  def context(file, checks)
    "\n  File:    #{file}\n  What:    #{checks[:description]}\n  Tickets: #{checks.fetch(:tickets, ['-']).join(', ')}\n"
  end

  # Decidim code our file touches that its targets don't cover
  def uncovered(file, targets)
    return [file] - targets.fetch(:files, {}).keys.map { |key| without_gem(key) } if REPLACED.include?(file)
    return uncovered_by_ruby_override(file, targets) if RUBY_OVERRIDES.include?(file)

    []
  end

  # Each method the override defines, unless the targets cover its whole class or the class's file
  def uncovered_by_ruby_override(file, targets)
    constant, methods = parse_override(file)
    class_file = Module.const_source_location(constant)&.first
    return [] if targets.fetch(:classes, {}).key?(constant)
    return [] if targets.fetch(:files, {}).keys.any? { |key| decidim_file(key) == class_file }

    methods.map { |method| "#{constant}##{method}" } - targets.fetch(:methods, {}).keys
  end

  # The patched constant and the methods an override defines
  def parse_override(file)
    nodes = all_nodes(Prism.parse_file(Rails.root.join(file).to_s).value)
    class_eval = nodes.find { |node| node.is_a?(Prism::CallNode) && node.name == :class_eval }
    [class_eval.receiver.full_name, nodes.grep(Prism::DefNode).map { |node| node.name.to_s }]
  end

  def md5_of(kind, name)
    case kind
    when :files then (path = decidim_file(name)) && Digest::MD5.file(path).hexdigest
    when :classes then md5(class_node(name)&.slice)
    when :methods then md5(method_node(*name.split('#'))&.slice)
    end
  end

  def gem_name(key)
    first = key.split('/').first
    first if DECIDIM_GEM_DIRS.key?(first)
  end

  def without_gem(key)
    key.delete_prefix("#{gem_name(key)}/")
  end

  # Absolute path of a Decidim file, given as 'path' or 'gem/path'
  def decidim_file(key)
    dirs = gem_name(key) ? [DECIDIM_GEM_DIRS[gem_name(key)]] : DECIDIM_GEM_DIRS.values
    found = dirs.map { |dir| File.join(dir, without_gem(key)) }.select { |path| File.file?(path) }
    flunk "#{key} exists in several Decidim gems, prefix it with the gem name" if found.size > 1
    found.first
  end

  def class_node(constant)
    file = Module.const_source_location(constant)&.first
    return unless file

    all_nodes(Prism.parse_file(file).value).find do |node|
      node.is_a?(Prism::ClassNode) && node.constant_path.full_name.end_with?(constant.demodulize)
    end
  rescue NameError
    nil
  end

  def method_node(constant, method)
    all_nodes(class_node(constant)).grep(Prism::DefNode).find { |node| node.name.to_s == method }
  end

  def md5(source)
    source && Digest::MD5.hexdigest(source)
  end

  def all_nodes(node)
    return [] unless node

    [node, *node.compact_child_nodes.flat_map { |child| all_nodes(child) }]
  end
end
