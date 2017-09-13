require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormTagHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#labelled_text_field_tag' do
    ##
    # <!-- Example HTML output -->
    # <div class="textfield js-highlight-control" id="participant_name-wrapper">
    #   <label class="textfield__label" for="participant_name">
    #     What is the name of the research participant?
    #     <span class="textfield__hint">Full name</span>
    #   </label>
    #   <input id="participant_name" class="textfield__input js-highlight-control__input"
    #       name="participant_name" type="text">
    # </div>
    context 'with a name and a label parameter' do
      let(:name) { :participant_name }
      let(:label) { 'What is the name of the research participant?' }

      subject(:rendered) { helper.labelled_text_field_tag(name, label) }

      it 'outputs an wrapper div with the class and id' do
        expect(rendered).to have_tag(
          'div',
          with: { class: 'textfield', id: 'participant_name-wrapper' }
        )
      end

      it 'renders a classed label and input as sibling children of the div' do
        expect(rendered).to have_tag('div.textfield > label.textfield__label', text: label)
        expect(rendered).to have_tag('div.textfield > input.textfield__input')
        expect(rendered).to have_tag('label[for=participant_name]')
      end

      it 'names the input as given' do
        expect(rendered).to have_tag('input', with: { name: 'participant_name', type: 'text' })
      end

      it 'adds classes to allow highlighter to enhance interaction' do
        expect(rendered).to have_tag('div.textfield.js-highlight-control')
        expect(rendered).to have_tag('input.textfield__input.js-highlight-control__input')
      end

      context 'with parameters intended for text_field_tag' do
        subject(:rendered) do
          helper.labelled_text_field_tag(
            name, label, text_options: { maxlength: 5, disabled: true }
          )
        end

        it 'passes them all through' do
          expect(rendered).to have_tag('input', with: { maxlength: 5, disabled: 'disabled' })
        end
      end

      context 'with a label field hint' do
        subject(:rendered) do
          helper.labelled_text_field_tag(
            name, label, label_options: { hint: 'Full name' }
          )
        end

        it 'renders a hint span in the label' do
          expect(rendered).to have_tag('label > span.textfield__hint', text: 'Full name')
        end
      end
    end

    context 'with a name, label and error' do
      let(:name) { :participant_name }
      let(:label) { 'What is the name of the research participant?' }

      subject(:rendered) { helper.labelled_text_field_tag(name, label, error: 'Error message') }

      it 'adds a class to the wrapper to indicate error' do
        expect(rendered).to have_tag('div.textfield.has-error')
      end

      it 'adds an element to display the error' do
        expect(rendered).to have_tag(
          'div.textfield.has-error > div.textfield__error', text: 'Error message'
        )
      end
    end
  end

  describe '#labelled_text_area_field_tag' do
    ##
    # <!-- Example HTML output -->
    # <div class="textfield js-highlight-control" id="participant_name-wrapper">
    #   <label class="textfield__label" for="participant_name">
    #     What is the name of the research participant?
    #     <span class="textfield__hint">Full name</span>
    #   </label>
    #   <textarea id="participant_name" class="textfield__input js-highlight-control__input"
    #       name="participant_name" type="text" rows="4">This is a test</textarea>
    # </div>
    let(:name) { :description }
    let(:label) { 'Describe the thing' }
    let(:value) { 'Some description text' }
    let(:label_options) { {} }
    let(:text_options) { {} }
    let(:error) {}

    subject(:rendered) do
      helper.labelled_text_area_tag(
        name,
        label,
        value,
        error: error,
        label_options: label_options,
        text_options: text_options
      )
    end

    context 'with a name and a label parameter' do
      it 'outputs an wrapper div with the class and id' do
        expect(rendered).to have_tag('div', with: { class: 'textarea', id: 'description-wrapper' })
      end

      it 'renders a label as a child of the wrapper' do
        expect(rendered).to have_tag(
          'div.textarea > label[for=description].textarea__label', text: label
        )
      end

      it 'renders a textarea as a child of the wrapper' do
        expect(rendered).to have_tag('div.textarea > textarea.textarea__input')
      end

      it 'renders a textarea with 5 rows' do
        expect(rendered).to have_tag('textarea.textarea__input[rows="4"]')
      end

      it 'names the textarea' do
        expect(rendered).to have_tag('textarea[name="description"].textarea__input')
      end

      it 'renders a textarea with the value' do
        expect(rendered).to have_tag('textarea.textarea__input', text: /^Some description text$/)
      end

      it 'adds classes to allow highlighter to enhance interaction' do
        expect(rendered).to have_tag('div.textarea.js-highlight-control')
        expect(rendered).to have_tag('textarea.textarea__input.js-highlight-control__input')
      end

      context 'with a hint' do
        let(:label_options) { { hint: 'Something helpful' } }

        it 'renders a hint span in the label' do
          expect(rendered).to have_tag(
            'label.textarea__label > span.textarea__hint', text: 'Something helpful'
          )
        end
      end
    end

    context 'with an error' do
      let(:error) { 'Error message' }

      it 'adds a class to the wrapper to indicate error' do
        expect(rendered).to have_tag('div.textarea.has-error')
      end

      it 'adds an element to display the error' do
        expect(rendered).to have_tag(
          'div.textarea.has-error > div.textarea__error', text: 'Error message'
        )
      end
    end

    context 'with a placeholder' do
      let(:text_options) { { placeholder: 'test placeholder' } }

      it 'should add a placeholder if provided' do
        expect(rendered).to have_tag('textarea[placeholder="test placeholder"].textarea__input')
      end
    end
  end

  describe '#checkbox_group_vertical' do
    # <!-- Example HTML output -->
    # <fieldset class="checkbox-group checkbox-group__vertical">
    #   <legend class="checkbox-group__legend">
    #     Some big legend
    #     <span class="checkbox-group__hint">Some more help for the label</span>
    #   </legend>
    #
    #   <div class="checkbox-group__choice">
    #     <input class="checkbox-group__input" id="age-under12" type="checkbox"
    #         name="age" value="under12">
    #     <label class="checkbox-group__label" for="age-under12">Under 12 years old</label>
    #   </div>
    # </fieldset>
    let(:name)            { :age }
    let(:legend)          { 'My legend' }
    let(:legend_options)  { {} }
    let(:values)          { ['one'] }

    let(:selection_options) do
      {
        'one' => 'A partridge in a pair tree',
        'two' => 'Two turtle doves',
        'three' => 'Three French hens'
      }
    end

    subject(:rendered) do
      helper.checkbox_group_vertical_tag(
        name,
        legend,
        selection_options,
        values,
        legend_options: legend_options
      )
    end

    context 'an empty enumerable is given' do
      let(:selection_options) { [] }

      let(:values) { [] }

      it 'generates an empty fieldset' do
        expect(rendered).to have_empty_tag('fieldset.checkbox-group.checkbox-group__vertical')
      end
    end

    shared_examples 'it has correctly classed and labelled input' do
      it 'renders a div with an input and label for each value' do
        expect(rendered).to have_tag('div.checkbox-group__choice', count: selection_options.length)
      end

      it 'renders a checbox input with the name and value and a constructed id' do
        expect(rendered).to have_tag(
          'input.checkbox-group__input',
          with: {
            type: 'checkbox', name: 'age', value: 'one', id: 'age-one'
          }
        )
      end

      it 'labels the input' do
        expect(rendered).to have_tag('label.checkbox-group__label', with: { for: 'age-one' })
      end

      it 'renders a legend with the value specified' do
        expect(rendered).to have_tag('legend.checkbox-group__legend', text: 'My legend')
      end
    end

    context 'an enumerable of value/text array pairs is given' do
      let(:selection_options) do
        [
          ['one',   'A partridge in a pair tree'],
          ['two',   'Two turtle doves'],
          ['three', 'Three French hens']
        ]
      end

      it_behaves_like 'it has correctly classed and labelled input'
    end

    context 'a hash of value/text pairs is given' do
      let(:selection_options) do
        {
          'one' => 'A partridge in a pair tree',
          'two' => 'Two turtle doves',
          'three' => 'Three French hens'
        }
      end

      it_behaves_like 'it has correctly classed and labelled input'
    end

    context 'a legend with optional class specified' do
      let(:legend_options) { { class: 'test' } }

      it 'includes an optional class in the legend' do
        expect(rendered).to have_tag('legend.checkbox-group__legend.test', text: 'My legend')
      end
    end

    context 'a legend with an optional hint specified' do
      let(:legend_options) { { hint: 'A hint' } }

      it 'includes an optional hint in the legend' do
        expect(rendered).to have_tag(
          'legend.checkbox-group__legend span.checkbox-group__hint', text: 'A hint'
        )
      end
    end

    context 'a single field value is supplied' do
      let(:values) { ['one'] }

      it 'marks a single checkbox for a single value' do
        expect(rendered).to have_tag('#age-one[checked="checked"]')
      end
      it 'does not check inputs that have not been selected' do
        expect(rendered).to have_tag('#age-two:not([checked])')
        expect(rendered).to have_tag('#age-three:not([checked])')
      end
    end

    context 'multiple field values are supplied' do
      context 'as strings' do
        let(:values) { ['one', 'three'] }

        it 'marks multiple checkboxes for multiple values' do
          expect(rendered).to have_tag('#age-one[checked="checked"]', checked: true)
          expect(rendered).to have_tag('#age-three[checked="checked"]', checked: true)
        end

        it 'does not check inputs that have not been selected' do
          expect(rendered).to have_tag('#age-two:not([checked])')
        end
      end

      context 'as symbols' do
        let(:values) { [:one, :three] }

        it 'marks multiple checkboxes for multiple values' do
          expect(rendered).to have_tag('#age-one[checked="checked"]', checked: true)
          expect(rendered).to have_tag('#age-three[checked="checked"]', checked: true)
        end

        it 'does not check inputs that have not been selected' do
          expect(rendered).to have_tag('#age-two:not([checked])')
        end
      end
    end
  end

  describe '#radio_group_vertical_tag' do
    # <!-- Example HTML output -->
    # <fieldset class="radio-group radio-group__vertical">
    #   <legend class="radio-group__legend">
    #     Some big legend
    #     <span class="radio-group__hint">Some more help for the label</span>
    #   </legend>
    #
    #   <div class="radio-group__choice">
    #     <input class="radio-group__input" id="age-under12" type="radio"
    #         name="age" value="under12">
    #     <label class="radio-group__label" for="age-under12">Under 12 years old</label>
    #   </div>
    # </fieldset>
    let(:name)           { :age }
    let(:legend)         { 'My legend' }
    let(:legend_options) { {} }
    let(:value) { '12to18' }

    let(:selection_options) do
      {
        :under12 => 'Under 12 years old',
        '12to18' => '12 to 18 years old'
      }
    end

    subject(:rendered) do
      helper.radio_group_vertical_tag(
        name,
        legend,
        selection_options,
        value,
        legend_options: legend_options
      )
    end

    context 'an empty enumerable is given' do
      let(:selection_options) { [] }

      it 'generates an empty fieldset' do
        expect(rendered).to have_empty_tag('fieldset.radio-group.radio-group__vertical')
      end
    end

    shared_examples 'it has correctly classed and labelled input' do
      it 'renders a div with an input and label for each value' do
        expect(rendered).to have_tag('div.radio-group__choice', count: selection_options.length)
      end

      it 'renders an radio input with the name and value and a constructed id' do
        expect(rendered).to have_tag(
          'input.radio-group__input',
          with: {
            type: 'radio', name: 'age', value: 'under12', id: 'age-under12'
          }
        )
      end

      it 'labels the input' do
        expect(rendered).to have_tag('label.radio-group__label', with: { for: 'age-under12' })
      end
    end

    context 'an enumerable of value/text array pairs is given' do
      let(:selection_options) do
        [
          [:under12, 'Under 12 years old'],
          ['12to18', '12 to 18 years old']
        ]
      end

      it_behaves_like 'it has correctly classed and labelled input'
    end

    context 'a hash of value/text pairs is given' do
      let(:selection_options) do
        {
          :under12 => 'Under 12 years old',
          '12to18' => '12 to 18 years old'
        }
      end

      it_behaves_like 'it has correctly classed and labelled input'
    end

    context 'a valid legend is specified' do
      it 'renders a legend with the value specified' do
        expect(rendered).to have_tag('legend.radio-group__legend', text: 'My legend')
      end
    end

    context 'a legend with optional class specified' do
      let(:legend_options) { { class: 'test' } }

      it 'includes an optional class in the legend' do
        expect(rendered).to have_tag('legend.radio-group__legend.test', text: 'My legend')
      end
    end

    context 'a legend with an optional hint specified' do
      let(:legend_options) { { hint: 'A hint' } }

      it 'includes an optional hint in the legend' do
        expect(rendered).to have_tag(
          'legend.radio-group__legend span.radio-group__hint', text: 'A hint'
        )
      end
    end

    context 'a field value is supplied' do
      let(:selection_options) do
        {
          one:   'A partridge in a pair tree',
          two:   'Two turtle doves',
          three: 'Three French hens'
        }
      end
      let(:value) { :one }

      it 'marks a single radio for the value' do
        expect(rendered).to have_tag('#age-one[checked="checked"]')
      end
      it 'does not check inputs that have not been selected' do
        expect(rendered).not_to have_tag('#age-two[checked="checked"]')
        expect(rendered).not_to have_tag('#age-three[checked="checked"]')
      end
    end
  end
end
