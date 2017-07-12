require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormHelpers, :type => :helper do
  include RSpecHtmlMatchers

  describe '#labelled_text_field_tag' do
    ##
    # <!-- Example HTML output -->
    # <div class="textfield " id="participant_name-wrapper">
    #   <label class="textfield__label textfield__label--bold" for="participant_name">
    #     What is the name of the research participant?
    #     <span class="textfield__hint">Full name</span>
    #   </label>
    #   <input id="participant_name" class="textfield__input" name="participant_name" type="text">
    # </div>
    context 'with a name and a label parameter' do
      let(:name) { :participant_name }
      let(:label) { 'What is the name of the research participant?' }

      subject(:rendered) { helper.labelled_text_field_tag(name, label) }

      it 'outputs an wrapper div with the class and id' do
        expect(rendered).to have_tag('div', with: { class: 'textfield', id: 'participant_name-wrapper' })
      end

      it 'renders a classed bold label and input as sibling children of the div' do
        expect(rendered).to have_tag('div.textfield > label.textfield__label.textfield__label--bold', text: label)
        expect(rendered).to have_tag('div.textfield > input.textfield__input')
        expect(rendered).to have_tag('label[for=participant_name]')
      end

      it 'names the input as given' do
        expect(rendered).to have_tag('input', with: { name: 'participant_name', type: 'text' })
      end

      context 'with parameters intended for text_field_tag' do
        subject(:rendered) do
          helper.labelled_text_field_tag(
            name, label, text_options: {maxlength: 5, disabled: true})
        end

        it 'passes them all through' do
          expect(rendered).to have_tag('input', with: { maxlength: 5, disabled: 'disabled' })
        end
      end

      context 'with a label field hint' do
        subject(:rendered) do
          helper.labelled_text_field_tag(
            name, label, label_options: { hint: 'Full name' })
        end

        it 'renders a hint span in the label' do
          expect(rendered).to have_tag('label > span.textfield__hint', text: 'Full name')
        end
      end
    end
  end

  describe '#vertical_radio_list' do
    # <!-- Example HTML output -->
    # <fieldset class="vertical-radio-list">
    # <legend class="vertical-radio-list__legend"></legend>
    #
    # <div class="vertical-radio-list__choice">
    #     <input class="vertical-radio-list__checkbox" id="age-under12" type="radio" name="age" value="under12">
    #     <label class="vertical-radio-list__label" for="age-under12">Under 12 years old</label>
    # </div>
    #
    # ...
    #
    # <div class="vertical-radio-list__choice">
    #     <input class="vertical-radio-list__checkbox" id="age-over18" type="radio" name="age" value="over18">
    #     <label class="vertical-radio-list__label" for="age-over18">Over 18 years old</label>
    # </div>
    # </fieldset>
    let(:name) { :age }

    subject(:rendered) { helper.vertical_radio_list(name, selection_options) }

    context 'an empty enumerable is given' do
      let(:selection_options) { [] }

      it 'generates an empty fieldset' do
        expect(rendered).to have_empty_tag('fieldset.vertical-radio-list')
      end
    end

    shared_examples 'it has correctly classed and labelled input' do
      it 'renders a div with an input and label for each value' do
        expect(rendered).to have_tag('div.vertical-radio-list__choice', count: selection_options.length)
      end

      it 'renders an radio input with the name and value and a constructed id' do
        expect(rendered).to have_tag(
                              'input.vertical-radio-list__checkbox',
                              with: {
                                type: 'radio', name: 'age', value: 'under12', id: 'age-under12'
                              }
                            )
      end

      it 'labels the input' do
        expect(rendered).to have_tag('label.vertical-radio-list__label', with: {for: 'age-under12'})
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
  end
end
