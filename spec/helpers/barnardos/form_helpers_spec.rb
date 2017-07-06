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
end
