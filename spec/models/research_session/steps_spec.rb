require 'rails_helper'

RSpec.describe ResearchSession::Steps do
  let(:status)  { 'new' }
  let(:session) { spy('ResearchSession') }
  let(:steps)   { ResearchSession::Steps.instance }

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
