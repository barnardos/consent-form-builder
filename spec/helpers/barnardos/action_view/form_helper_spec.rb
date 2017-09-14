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

  describe '#labelled_text_area' do
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

    let(:label)         { nil }
    let(:label_options) { {} }
    let(:text_options)  { {} }

    subject(:rendered) do
      helper.labelled_text_area(
        :research_session, :topic, label: label, label_options: label_options,
                                   text_options: text_options
      )
    end

    context 'with only the object name and method' do
      before do
        research_session = double('ResearchSession', topic: 'Topic from the object')
        assign(:research_session, research_session)
      end

      it 'outputs an wrapper div with the class and id' do
        expect(rendered).to have_tag(
          'div.textarea.js-highlight-control', with: { id: 'topic-wrapper' }
        )
      end

      it 'renders what is on the named object in a highlighted control' do
        expect(rendered).to have_tag('textarea.textarea__input', text: /Topic from the object/)
      end

      it 'labels according to en.yml' do
        expect(rendered).to have_tag(
          'label', text: 'What is the research or participation session about?'
        )
      end

      it 'renders a textarea with 4 rows' do
        expect(rendered).to have_tag('textarea.textarea__input[rows="4"]')
      end

      it 'adds classes to allow highlighter to enhance interaction' do
        expect(rendered).to have_tag('div.textarea.js-highlight-control')
        expect(rendered).to have_tag('textarea.textarea__input.js-highlight-control__input')
      end
    end

    context 'a label is given as a keyword param' do
      let(:label) { 'A label' }

      it 'renders a label as a child of the wrapper' do
        expect(rendered).to have_tag(
          'div.textarea > label[for=research_session_topic].textarea__label', text: label
        )
      end
    end

    context 'label_options specifies a hint' do
      let(:label_options) { { hint: 'Something helpful' } }

      it 'renders a hint span in the label' do
        expect(rendered).to have_tag(
          'label.textarea__label > span.textarea__hint', text: 'Something helpful'
        )
      end
    end

    context 'text_options specifies a placeholder' do
      let(:text_options) { { placeholder: 'test placeholder' } }

      it 'adds a placeholder' do
        expect(rendered).to have_tag('textarea[placeholder="test placeholder"].textarea__input')
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

  describe '#checkbox_group_vertical' do
    let(:legend)         { 'My legend' }
    let(:legend_options) { {} }
    let(:collection) do
      {
        interview: 'Interview',
        usability: 'Usability testing',
        survey:    'Survey'
      }
    end

    before do
      assign(
        :research_session,
        double(:research_session, methodologies: %w[interview survey])
      )
    end

    subject(:rendered) do
      helper.checkbox_group_vertical(
        :research_session, :methodologies, collection,
        legend: legend, legend_options: legend_options
      )
    end

    shared_examples 'it has correctly classed, labelled and selected inputs' do
      it 'renders a div with an input and label for each value' do
        expect(rendered).to have_tag('div.checkbox-group__choice', count: collection.length)
      end

      it 'renders a selected checkbox input with the name and value and a constructed id' do
        expect(rendered).to have_tag(
          'input.checkbox-group__input',
          with: {
            type: 'checkbox',
            name: 'research_session[methodologies][]',
            value: 'interview',
            id: 'research_session_methodologies_interview'
          }
        )
      end

      it 'labels the input' do
        expect(rendered).to have_tag(
          'label.checkbox-group__label', with: { for: 'research_session_methodologies_interview' }
        )
      end

      it 'renders a legend with the value specified' do
        expect(rendered).to have_tag('legend.checkbox-group__legend', text: 'My legend')
      end

      it 'checks inputs whose values are present' do
        expect(rendered).to have_tag('#research_session_methodologies_interview[checked="checked"]')
        expect(rendered).to have_tag('#research_session_methodologies_survey[checked="checked"]')
      end
      it "'does not check those that aren't'" do
        expect(rendered).to have_tag('#research_session_methodologies_usability:not([checked])')
      end
    end

    context 'an empty enumerable is given' do
      let(:collection) { [] }

      it 'generates an empty fieldset' do
        expect(rendered).to have_empty_tag('fieldset.checkbox-group.checkbox-group__vertical')
      end
    end

    context 'a hash of name/value pairs is given' do
      it_behaves_like 'it has correctly classed, labelled and selected inputs'
    end

    context 'an Array of value/text array pairs is given' do
      let(:collection) do
        [
          [:interview, 'Interview'],
          [:usability, 'Usability testing'],
          [:survey,    'Survey']
        ]
      end

      it_behaves_like 'it has correctly classed, labelled and selected inputs'
    end

    context 'a legend class is specified' do
      let(:legend_options) { { class: 'test' } }

      it 'includes that class in the legend' do
        expect(rendered).to have_tag('legend.checkbox-group__legend.test', text: 'My legend')
      end
    end

    context 'a legend hint is specified' do
      let(:legend_options) { { hint: 'A hint' } }

      it 'includes the hint in the legend' do
        expect(rendered).to have_tag(
          'legend.checkbox-group__legend span.checkbox-group__hint', text: 'A hint'
        )
      end
    end
  end
end
