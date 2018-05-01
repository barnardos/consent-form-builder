require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#link_to_current_sha' do
    let(:sha_getter) { -> { `git rev-parse HEAD` } }
    subject(:release_sha) { helper.release_sha(sha_getter) }
    subject(:release_url) { helper.release_url }

    context 'in development' do
      let(:current_sha) { `git rev-parse HEAD` }

      before { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it 'is the current HEAD SHA' do
        expect(release_sha).to eq(current_sha)
        expect(release_url).to eq(ApplicationHelper::COMMIT_STEM + release_sha)
      end
    end

    context 'in production' do
      let(:heroku_slug_commit) { '169cea1b98b91af691ee5f029e3afcc9dea9408b' }

      before { ENV['HEROKU_SLUG_COMMIT'] = heroku_slug_commit }
      after  { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it 'is from the HEROKU_SLUG_COMMIT var' do
        expect(release_sha).to eq(heroku_slug_commit)
        expect(release_url).to eq(ApplicationHelper::COMMIT_STEM + heroku_slug_commit)
      end
    end
  end

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
