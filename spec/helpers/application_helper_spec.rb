# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#release_sha' do
    let(:sha_getter) { -> { `git rev-parse HEAD` } }
    subject(:release_sha) { helper.release_sha(sha_getter) }

    context 'in development' do
      let(:current_sha) { `git rev-parse HEAD` }
      before { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it { is_expected.to eql(current_sha) }
    end

    context 'in production' do
      let(:heroku_slug_commit) { '169cea1b98b91af691ee5f029e3afcc9dea9408b' }
      before { ENV['HEROKU_SLUG_COMMIT'] = heroku_slug_commit }
      after  { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it { is_expected.to eql(heroku_slug_commit) }
    end

    context 'in some other env that does not have a repo or an env var' do
      let(:sha_getter) { -> { nil } }
      before { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it { is_expected.to eql('unavailable') }
    end
  end

  describe '#release_url' do
    subject(:release_url) { helper.release_url }
    let(:release_sha) { helper.release_sha(-> { `git rev-parse HEAD` }) }

    it { is_expected.to eql(ApplicationHelper::COMMIT_STEM + release_sha) }
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
