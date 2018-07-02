require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#title' do
    subject(:title) { helper.title(research_session, step) }

    context 'We are at the start' do
      let(:step) { nil }
      let(:research_session) { ResearchSession.new }

      it { is_expected.to eql('Create a new form – Consent Form Builder') }
    end

    context 'We are at a normal step' do
      let(:step) { :researcher }
      let(:research_session) { create :research_session, :step_researcher }

      it { is_expected.to eql('Researcher – My session') }
    end

    context 'We are at the preview' do
      let(:step) { nil }
      let(:research_session) { create :research_session, :previewable }

      it { is_expected.to eql('Preview & print – My session') }
    end

    context 'We are not looking at a research session at all' do
      let(:step) { nil }
      let(:research_session) { nil }

      it { is_expected.to eql('Consent Form Builder') }
    end
  end
end
