require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormBuilder do
  include RSpecHtmlMatchers

  class TestHelperCarrier < ActionView::Base
    include Barnardos::ActionView::FormHelper
  end

  let(:helper)  { TestHelperCarrier.new }
  let(:builder) { Barnardos::ActionView::FormBuilder.new(:research_session, model, helper, {}) }
  let(:model)   { ResearchSession.new topic: 'somevalue' }

  describe '#labelled_text_field' do
    subject(:rendered) { builder.labelled_text_field(:topic) }

    it 'populates values as it should' do
      expect(rendered).to have_tag('input[value=somevalue]')
    end

    it 'preserves default ids so that labels work' do
      expect(rendered).to have_tag('input[id=research_session_topic]')
    end
  end

  describe '#labelled_text_area' do
    subject(:rendered) { builder.labelled_text_area(:topic) }

    it 'populates values as it should' do
      expect(rendered).to have_tag('textarea', text: /somevalue/)
    end

    it 'preserves default ids so that labels work' do
      expect(rendered).to have_tag('textarea[id=research_session_topic]')
    end
  end
end
