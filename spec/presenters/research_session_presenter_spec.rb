require 'rails_helper'

RSpec.describe ResearchSessionPresenter do
  include RSpecHtmlMatchers

  let(:research_session) { spy('ResearchSession') }

  subject(:presenter) { ResearchSessionPresenter.new(research_session) }

  it 'holds on to the research session' do
    expect(presenter.research_session).to eql(research_session)
  end

  [:age, :topic, :purpose, :researcher_name, :researcher_other_name,
   :researcher_email, :researcher_phone].each do |method|
    it "delegates #{method} to the research_session" do
      presenter.send method
      expect(research_session).to have_received(method)
    end
  end

  describe '#methodology_list' do
    let(:methodologies) { [:interview, :usability] }
    before do
      allow(research_session).to receive(:age).and_return(age)
      allow(research_session).to receive(:methodologies).and_return(methodologies)
    end

    subject(:list) { presenter.methodology_list }

    context 'the research session is targeted at children' do
      let(:age) { 'under18' }
      it 'has as many paragraphs as there are methodologies' do
        expect(list).to have_tag('p', count: 2)
      end
      it 'assembles a child-appropriate list of methodology segments' do
        expect(list).to include('Your child will be interviewed')
        expect(list).to include('Your child will be asked')
      end
      it 'is html_safe' do
        expect(list).to be_html_safe
      end
    end

    context 'the research session is targeted at adults' do
      let(:age) { 'over18' }
      it 'has as many paragraphs as there are methodologies' do
        expect(list).to have_tag('p', count: 2)
      end
      it 'assembles an adult-appropriate list of methodology segments' do
        expect(list).to include('You will be interviewed')
        expect(list).to include('You will be asked')
      end

      context 'the research session contains "other"' do
        let(:methodologies) { [:interview, :usability, :other] }
        before { allow(research_session).to receive(:other_methodology).and_return('Reiki') }

        it 'has it all' do
          expect(list).to include('Reiki')
        end
      end
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
      let(:recording_methods) { [:audio] }
      it { is_expected.to eql('audio') }
    end

    context 'there are two recording methods' do
      let(:recording_methods) { [:audio, :video] }
      it { is_expected.to eql('audio and video') }
    end

    context 'there are three recording methods' do
      let(:recording_methods) { [:audio, :video, :written] }
      it { is_expected.to eql('audio, video, and written notes') }
    end

    context 'there are three recording methods and one is "other"' do
      let(:recording_methods) { [:audio, :video, :other] }
      let(:other_recording_method) { 'comic books' }
      it { is_expected.to eql('audio, video, and comic books') }
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
      let(:research_session) { build_stubbed :expenses }
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
        build_stubbed :time_equipment, travel_expenses_limit: 50.00
      end
      it { is_expected.to eql('We allow travel expenses of up to £50.00.') }
    end

    context 'Two expenses are given' do
      let(:research_session) do
        build_stubbed :time_equipment,
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
        build_stubbed :time_equipment,
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
      let(:research_session) { build_stubbed :incentive, incentive: false }
      it { is_expected.to be_empty }
    end

    let(:formatted_value) do
      format('%.02f', research_session.incentive_value)
    end

    context 'a cash incentive is provided' do
      let(:research_session) { build_stubbed :incentive }
      it 'has a message about the cash value' do
        expect(text).to eql(
          "a cash incentive of £#{formatted_value}"
        )
      end
    end

    context 'a high street voucher incentive is provided' do
      let(:research_session) { build_stubbed :incentive, payment_type: 'voucher' }
      it 'has a message about the high street voucher value' do
        expect(text).to eql(
          "high street vouchers to the value of £#{formatted_value}"
        )
      end
    end
  end
end
