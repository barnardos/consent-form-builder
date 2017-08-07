require 'rails_helper'

RSpec.describe ResearchSession::Steps do
  let(:steps) { ResearchSession::Steps.instance }

  describe '#reached_step?' do
    let(:status)  { 'new' }
    let(:session) { spy('ResearchSession') }

    before  { allow(session).to receive(:status).and_return(status) }

    subject { steps.reached_step?(session, at_least) }

    context 'no state given beyond default new' do
      let(:at_least) { 'methodologies' }

      it { is_expected.to be false }
    end
    context 'invalid state given beyond the first state of new' do
      let(:status) { 'age' }
      it 'raises an error' do
        expect { steps.reached_step?(session, 'invalid-state') }.to \
          raise_error(KeyError, /not found/)
      end
    end
    context 'we are at the first stage' do
      let(:status)   { 'age' }
      let(:at_least) { 'methodologies' }

      it { is_expected.to be false }
    end
    context 'we have reached the stage we are testing' do
      let(:status)   { 'methodologies' }
      let(:at_least) { 'methodologies' }

      it { is_expected.to be true }
    end
    context 'we are past the stage we are testing' do
      let(:status)   { 'incentive' }
      let(:at_least) { 'methodologies' }

      it { is_expected.to be true }
    end
  end

  describe '#attr_to_step' do
    subject(:step) { steps.attr_to_step(attr) }

    context 'the attr does not exist' do
      it 'raises a KeyError' do
        expect { steps.attr_to_step('i-dont-exist') }.to \
          raise_error(KeyError, /i-dont-exist/)
      end
    end

    context 'the attr is a researcher attribute' do
      let(:attr) { :researcher_name }

      it 'goes to the researcher page' do
        expect(step).to eql(:researcher)
      end
    end

    context 'the attr is a methodologies (array) attribute' do
      let(:attr) { :methodologies }

      it 'goes to the methodologies page' do
        expect(step).to eql(:methodologies)
      end
    end
  end
end
