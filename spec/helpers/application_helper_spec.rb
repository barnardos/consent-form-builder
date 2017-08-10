require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#link_to_current_sha' do
    let(:sha_getter) { -> { `git rev-parse HEAD` } }
    subject(:link) { helper.link_to_current_sha(sha_getter) }

    context 'in development' do
      let(:current_head_sha) { `git rev-parse HEAD` }

      before { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it 'is the current HEAD SHA' do
        expect(link).to have_tag(
          'a',
          text: current_head_sha[0..7],
          href: "#{ApplicationHelper::COMMIT_STEM}#{current_head_sha}"
        )
      end
    end

    context 'in production' do
      let(:heroku_slug_commit) { '169cea1b98b91af691ee5f029e3afcc9dea9408b' }

      before { ENV['HEROKU_SLUG_COMMIT'] = heroku_slug_commit }
      after  { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it 'is from the HEROKU_SLUG_COMMIT var' do
        expect(link).to have_tag(
          'a',
          text: heroku_slug_commit[0..7],
          href: "#{ApplicationHelper::COMMIT_STEM}#{heroku_slug_commit}"
        )
      end
    end

    context 'in some other env that does not have a repo or an env var' do
      let(:sha_getter) { -> { nil } }
      before { ENV['HEROKU_SLUG_COMMIT'] = nil }

      it { is_expected.to eql('unavailable') }
    end
  end
end
