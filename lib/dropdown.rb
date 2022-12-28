class CustomSingleOptionSurvey
  def initialize(context, answer, answer_idx, disabled)
    @context = context
    @answer = answer
    @answer_idx = answer_idx
    @disabled = disabled
  end

  def dropdown?
    first_text =~ /!dropdown!/ && options.none?(&:free_text)
  end

  def sorted?
    first_text =~ /!sort!/
  end

  def mandatory?
    @answer.question.mandatory
  end

  def select_id
    "select_#{@answer_idx}"
  end

  def select_tag
    @context.select_tag(
      select_id,
      select_tag_options,
      disabled: @disabled,
      class: 'dropdown-select',
      data: { answer: @answer_idx }
    )
  end

  def select_tag_options
    opts = translate_options(sorted_options)
    opts = opts.prepend(['', nil]) unless mandatory?

    @context.options_for_select(opts)
  end

  def radio_button_options
    sorted_options
  end

  def translate_options(opts)
    opts.map {|opt,idx| [translate(opt.body), idx] }
  end

  def sorted_options
    return indexed_options if !dropdown? && !sorted?
    return indexed_options[1..] unless sorted?

    indexed_options[1..].sort_by { |o| transliterate(translate(o[0].body)) }
  end

  def selected_option
    first_answer = @answer.choices.first.try(:answer_option_id)
    first_option = dropdown? && mandatory? && sorted_options.first.first.id

    first_answer || first_option || nil
  end

  def dropdown_javascript
    <<~JAVASCRIPT
      <script>
        if (!window.dropdown_init_registered) {
          window.addEventListener('load', () => {
            const selects = document.querySelectorAll('.dropdown-select');

            selects.forEach((select) => {
              select.addEventListener('change', () => {
                if (select.value != '') {
                  let answer_body = '#questionnaire_responses_' + select.dataset.answer + '_choices_' + select.value + '_body';
                  let option = document.querySelector(answer_body);

                  option.click();
                } else {
                  let radios = select.parentNode.querySelectorAll('.radio-button-collection input[type=radio]');
                  let selected = Array.from(radios).filter(radio => {return radio.checked});

                  selected.forEach(radio => {radio.checked = false});
                }
              });
            })
          });

          window.dropdown_init_registered = true
        }
      </script>
    JAVASCRIPT
  end

  def radio_button_class
    return 'hide' if dropdown?

    ''
  end

  private

  def first_text
    @context.translated_attribute(options.first.body)
  end

  def options
    @answer.question.answer_options
  end

  def indexed_options
    options.each_with_index.to_a
  end

  def translate(attribute)
    @context.translated_attribute(attribute)
  end

  def transliterate(text)
    I18n.transliterate(text)
  end

end
