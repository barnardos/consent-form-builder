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
end
