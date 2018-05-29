require 'rails_helper'

RSpec.describe ResearchSessionPresenter do
  include RSpecHtmlMatchers

  let(:topic) { 'from the research session' }
  let(:research_session) { ResearchSession.new topic: topic, slug: 'my-session' }
  let(:able_to_consent) { false }

  subject(:presenter) do
    ResearchSessionPresenter.new(
      research_session,
      able_to_consent: able_to_consent
    )
  end

  it 'holds on to the research session' do
    expect(presenter.research_session).to eql(research_session)
  end

  it 'delegates to the research session' do
    expect(presenter.topic).to eql(topic)
  end

  it 'raises errors for attributes found neither on the presenter or model' do
    expect { presenter.i_dont_exist }.to raise_error(NoMethodError)
  end

  it 'does not respond to non-existent messages' do
    expect(presenter.respond_to?(:i_dont_exist)).to eql(false)
  end

  it 'responds to messages found only on the model' do
    expect(presenter.respond_to?(:persisted?)).to eql(true)
  end

  it 'delegates to_param despite that somehow existing on the base presenter' do
    expect(presenter.to_param).to eql(research_session.to_param)
  end

  describe '#un/able_to_consent?' do
    context 'participant is unable to consent' do
      let(:able_to_consent) { false }
      it { is_expected.not_to be_able_to_consent }
      it { is_expected.to be_unable_to_consent }
    end
    context 'participant is able to consent' do
      let(:able_to_consent) { true }
      it { is_expected.to be_able_to_consent }
      it { is_expected.not_to be_unable_to_consent }
    end
  end

  describe '#any_expenses?' do
    subject { presenter.any_expenses? }

    context 'no expenses given (all nil)' do
      let(:research_session) { build_stubbed :research_session, :nil_expenses }
      it { is_expected.to be false }
    end

    context 'no expenses given (all zero)' do
      let(:research_session) { build_stubbed :research_session, :zero_expenses }
      it { is_expected.to be false }
    end

    context 'expenses given' do
      let(:research_session) { build_stubbed :research_session, :step_expenses }
      it { is_expected.to be true }
    end
  end
end
