require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormHelpers, :type => :helper do
  include RSpecHtmlMatchers

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
    let(:error) {}

    subject(:rendered) do
      helper.labelled_text_area_tag(name,
                                    label,
                                    value,
                                    error: error,
                                    label_options: label_options)
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
        let(:label_options) { { :hint => 'Something helpful' } }

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
  end
end
