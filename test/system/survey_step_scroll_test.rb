# frozen_string_literal: true

require 'application_system_test_case'
require 'factory_bot'
require 'decidim/surveys/test/factories'

# Switching survey steps must scroll to the start of the new step (#636),
# below core's sticky header on mobile.
class SurveyStepScrollTest < ApplicationSystemTestCase
  include FactoryBot::Syntax::Methods

  setup do
    organization = create(:organization, host: Capybara.server_host)
    process = create(:participatory_process, :published, :with_steps, organization:)
    component = create(:surveys_component, :published, participatory_space: process)
    survey = create(:survey, :published, :allow_responses, :allow_unregistered,
                    component:, questionnaire: create(:questionnaire))

    # Two steps taller than the window, so the step start is off-screen after switching
    question_types = Array.new(8, :long_response) + [:separator] + Array.new(8, :long_response)
    question_types.each_with_index do |question_type, position|
      create(:questionnaire_question, questionnaire: survey.questionnaire, position:, question_type:, mandatory: false,
                                      description: { en: "<p>#{'Lorem ipsum dolor sit amet. ' * 40}</p>" })
    end

    @survey_path = Decidim::EngineRouter.main_proxy(component).survey_path(survey)
  end

  test 'scrolls to the start of the new step' do
    visit_survey(1400, 1400)
    assert_step_switch_scrolls_to(0)
  end

  test 'keeps the step start clear of the sticky header on mobile' do
    visit_survey(390, 844)
    assert_step_switch_scrolls_to(evaluate_script("document.getElementById('sticky-header-container').offsetHeight"))
  end

  private

  # The browser window is shared between tests, so each test sets its own size.
  def visit_survey(width, height)
    page.current_window.resize_to(width, height)
    visit @survey_path
    click_on 'Accept all'
  end

  def assert_step_switch_scrolls_to(top)
    click_on 'Continue'
    assert_step_top('step-1', top)

    within('#step-1') { click_on 'Back' }
    assert_step_top('step-0', top)
  end

  def assert_step_top(id, expected)
    top = evaluate_script("document.getElementById('#{id}').getBoundingClientRect().top")
    assert_in_delta expected, top, 1, "##{id} start, px from viewport top"
  end
end
