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

  describe '#recording_methods_list' do
    let(:other_recording_method) { nil }

    subject(:list) { presenter.recording_methods_list }

    before do
      allow(research_session).to receive(:recording_methods).and_return(recording_methods)
      allow(research_session).to receive(:other_recording_method).and_return(other_recording_method)
    end

    context 'there is one recording method' do
      let(:recording_methods) { [:voice] }
      it { is_expected.to eql('voice recording') }
    end

    context 'there are two recording methods' do
      let(:recording_methods) { [:voice, :video] }
      it { is_expected.to eql('voice recording and video recording') }
    end

    context 'there are three recording methods' do
      let(:recording_methods) { [:voice, :video, :written] }
      it { is_expected.to eql('voice recording, video recording, and written notes') }
    end

    context 'there are three recording methods and one is "other"' do
      let(:recording_methods) { [:voice, :video, :other] }
      let(:other_recording_method) { 'comic books' }
      it { is_expected.to eql('voice recording, video recording, and comic books') }
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

  describe '#expenses_sentence' do
    subject { presenter.expenses_sentence }

    context 'no expenses given (all nil)' do
      let(:research_session) { build_stubbed :research_session, :nil_expenses }
      it { is_expected.to be_nil }
    end

    context 'no expenses given (all zero)' do
      let(:research_session) { build_stubbed :research_session, :zero_expenses }
      it { is_expected.to be_nil }
    end

    context 'One expense is given' do
      let(:research_session) do
        build_stubbed :research_session, :step_where_when, travel_expenses_limit: 50.00
      end
      it { is_expected.to eql('We allow travel expenses of up to £50.00.') }
    end

    context 'Two expenses are given' do
      let(:research_session) do
        build_stubbed :research_session, :step_where_when,
                      travel_expenses_limit: 50.00,
                      food_expenses_limit: 10.00
      end
      it do
        is_expected.to eql(
          'We allow travel expenses of up to £50.00 and food expenses of up to £10.00.'
        )
      end
    end

    context 'Three expenses are given' do
      let(:research_session) do
        build_stubbed :research_session, :step_where_when,
                      travel_expenses_limit: 50.00,
                      food_expenses_limit: 10.00,
                      other_expenses_limit: 5.00
      end
      it do
        is_expected.to eql(
          'We allow travel expenses of up to £50.00, food expenses of up to £10.00, '\
          'and other expenses of up to £5.00.'
        )
      end
    end
  end

  describe '#incentive_text' do
    subject(:text) { presenter.incentive_text }

    context 'no incentive is given' do
      let(:research_session) do
        build_stubbed :research_session, :step_incentives, incentives_enabled: false
      end
      it { is_expected.to be_empty }
    end

    let(:formatted_value) do
      format('%.02f', research_session.incentive_value)
    end

    context 'a cash incentive is provided' do
      let(:research_session) { build_stubbed :research_session, :step_incentives }
      it 'has a message about the cash value' do
        expect(text).to eql(
          "a cash incentive of £#{formatted_value}"
        )
      end
    end

    context 'a high street voucher incentive is provided' do
      let(:research_session) do
        build_stubbed :research_session, :step_incentives, payment_type: 'voucher'
      end
      it 'has a message about the high street voucher value' do
        expect(text).to eql(
          "high street vouchers to the value of £#{formatted_value}"
        )
      end
    end
  end
end
