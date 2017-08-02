require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormHelpers, :type => :helper do
  include RSpecHtmlMatchers

  describe '#radio_group_vertical' do
    # <!-- Example HTML output -->
    # <fieldset class="radio-group radio-group__vertical">
    #   <legend class="radio-group__legend">
    #     Some big legend
    #     <span class="radio-group__hint">Some more help for the label</span>
    #   </legend>
    #
    #   <div class="radio-group__choice">
    #     <input class="radio-group__input" id="age-under12" type="radio" name="age" value="under12">
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
      helper.radio_group_vertical(name,
                                  legend,
                                  selection_options,
                                  value,
                                  legend_options: legend_options)
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
        expect(rendered).to have_tag('label.radio-group__label', with: {for: 'age-under12'})
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
      let(:legend_options) { {:class => 'test'} }

      it 'includes an optional class in the legend' do
        expect(rendered).to have_tag('legend.radio-group__legend.test', text: 'My legend')
      end
    end

    context 'a legend with an optional hint specified' do
      let(:legend_options) { {:hint => 'A hint'} }

      it 'includes an optional hint in the legend' do
        expect(rendered).to have_tag('legend.radio-group__legend span.radio-group__hint', text: 'A hint')
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
