require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormBuilder do
  include RSpecHtmlMatchers

  class TestHelperCarrier < ActionView::Base
    include Barnardos::ActionView::FormHelper
  end

  let(:helper)  { TestHelperCarrier.new }
  let(:builder) { Barnardos::ActionView::FormBuilder.new(:research_session, model, helper, {}) }

  describe '#labelled_text_field' do
    let(:model) { ResearchSession.new topic: 'somevalue' }

    subject(:rendered) { builder.labelled_text_field(:topic) }

    it 'populates values as it should' do
      expect(rendered).to have_tag('input[value=somevalue]')
    end

    it 'preserves default ids so that labels work' do
      expect(rendered).to have_tag('input[id=research_session_topic]')
    end
  end

  describe '#labelled_text_area' do
    let(:model) { ResearchSession.new topic: 'somevalue' }

    subject(:rendered) { builder.labelled_text_area(:topic) }

    it 'populates values as it should' do
      expect(rendered).to have_tag('textarea', text: /somevalue/)
    end

    it 'preserves default ids so that labels work' do
      expect(rendered).to have_tag('textarea[id=research_session_topic]')
    end
  end

  describe '#checkbox_group_vertical' do
    let(:model) { ResearchSession.new methodologies: %w[interview audio] }

    let(:collection) do
      {
        interview: 'Interview',
        audio: 'Audio',
        other: 'Other'
      }
    end

    subject(:rendered) do
      builder.checkbox_group_vertical(:methodologies, collection)
    end

    it 'selects values checked on the model' do
      expect(rendered).to have_tag('input[value=interview][checked]')
      expect(rendered).to have_tag('input[value=audio][checked]')
    end
    it 'does not select values unchecked on the model' do
      expect(rendered).to have_tag('input:not(checked)[value=other]')
    end
  end

  describe '#radio_group_vertical' do
    let(:model) { ResearchSession.new shared_with: 'team' }

    let(:collection) do
      {
        team: 'Just the team',
        internal: 'Other teams internally',
        external: 'Other teams externally'
      }
    end

    subject(:rendered) do
      builder.radio_group_vertical(:shared_with, collection)
    end

    it 'selects the value checked on the model' do
      expect(rendered).to have_tag('input[value=team][checked]')
    end
    it 'does not select values unchecked on the model' do
      expect(rendered).to have_tag('input:not(checked)[value=internal]')
      expect(rendered).to have_tag('input:not(checked)[value=external]')
    end
  end
end
