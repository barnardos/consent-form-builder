require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#barnardos_form_with' do
    subject(:rendered) { helper.barnardos_form_with model: ResearchSession.new, url: 'custom' }

    it 'looks just like another form' do
      expect(rendered).to have_tag('form[action=custom]')
    end
  end

  describe '#labelled_text_field' do
    let(:label_options) { {} }

    subject(:rendered) do
      helper.labelled_text_field :research_session, :researcher_name, label_options: label_options
    end

    context 'there is a value on research session' do
      before do
        research_session = double('ResearchSession', researcher_name: 'Alice')
        assign(:research_session, research_session)
      end

      it 'labels using the i18n value from helpers in en.yml' do
        expect(rendered).to have_tag('label', text: 'Full name')
      end

      it 'gets the value from the model' do
        expect(rendered).to have_tag('input[value=Alice]')
      end
    end

    context 'a hint is given' do
      let(:label_options) { { hint: 'A small hint' } }

      it 'renders the hint as a span' do
        expect(rendered).to have_tag('span.textfield__hint', text: 'A small hint')
      end
    end

    context 'A text value is given' do
      subject(:rendered) do
        helper.labelled_text_field :research_session, :researcher_name, 'A text value'
      end

      it 'renders that text' do
        expect(rendered).to have_tag('label', text: 'A text value')
      end
    end
  end

  describe '#radio_group_vertical' do
    before do
      research_session = double('ResearchSession', to_s: 'research_session', shared_with: :team)
      assign(:research_session, research_session)
    end

    let(:legend)         { 'My legend' }
    let(:legend_options) { { class: 'my-legend-class' } }

    let(:collection) do
      HashWithIndifferentAccess.new(
        team: 'Just the team',
        internal: 'Other teams internally',
        external: 'Other teams externally'
      )
    end

    subject(:rendered) do
      helper.radio_group_vertical(
        :research_session, :shared_with, collection,
        legend: legend, legend_options: legend_options
      )
    end

    context 'an empty enumerable is given' do
      let(:collection) { [] }

      it 'generates an empty fieldset' do
        expect(rendered).to have_empty_tag('fieldset.radio-group.radio-group__vertical')
      end
    end

    shared_examples 'it has a legend' do
      it 'has the classed legend' do
        expect(rendered).to have_tag(
          'legend.radio-group__legend.my-legend-class',
          text: legend
        )
      end
    end

    shared_examples 'it has correctly classed and labelled input' do
      it 'renders a div with an input and label for each value' do
        expect(rendered).to have_tag('div.radio-group__choice', count: collection.length)
      end

      it 'renders an radio input with the name and value and a constructed id' do
        expect(rendered).to have_tag(
          'input.radio-group__input',
          with: {
            type: 'radio', name: 'research_session[shared_with]',
            value: 'team', id: 'research_session_shared_with_team'
          }
        )
      end

      it 'labels the input' do
        expect(rendered).to have_tag(
          'label.radio-group__label', with: { for: 'research_session_shared_with_team' }
        )
      end

      it 'selects the current value' do
        expect(rendered).to have_tag('input[value=team][checked]')
      end
    end

    context 'a hash of value/text pairs is given' do
      it_behaves_like 'it has a legend'
      it_behaves_like 'it has correctly classed and labelled input'
    end

    context 'an enumerable of value/text array pairs is given' do
      let(:collection) do
        [
          [:team,     'Just the team'],
          [:internal, 'Other teams internally'],
          [:external, 'Other teams externally']
        ]
      end

      it_behaves_like 'it has a legend'
      it_behaves_like 'it has correctly classed and labelled input'
    end
  end
end
