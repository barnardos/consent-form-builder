require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormHelpers, :type => :helper do
  include RSpecHtmlMatchers

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
      helper.checkbox_group_vertical(name,
                                     legend,
                                     selection_options,
                                     values,
                                     legend_options: legend_options)
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
      let(:legend_options) { { :hint => 'A hint' } }

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
end
