require 'rails_helper'

RSpec.describe ResearchSession, type: :model do
  describe 'partial validation on status' do
    subject(:session) { ResearchSession.new }

    it 'creates a brand new ResearchSession with a status of new' do
      expect(session.status).to eql('new')
    end

    describe '#has_reached_step?' do
      let(:status) { 'new' }
      before { session.status = status }

      subject { session.has_reached_step?(at_least) }

      context 'no state given beyond default new' do
        let(:at_least) { 'methodologies' }

        it { is_expected.to be false }
      end
      context 'invalid state given beyond the first state of new' do
        let(:status) { 'age' }
        it 'raises an error' do
          expect { session.has_reached_step?('invalid-state') }.to \
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

    describe 'step-by-step validation' do
      before do
        session.status = step
      end

      describe 'validating the age step' do
        let(:step) { 'age' }

        before { session.age = age }

        context 'a blank age' do
          let(:age) { nil }
          it { is_expected.not_to be_valid }
        end

        context 'limiting to given age values' do
          context 'a given value' do
            Age.allowed_values.each do |allowed_age_value|
              let(:age) { allowed_age_value }
              it { is_expected.to be_valid }
            end
          end
          context 'a value outside of the enum' do
            let(:age) { 'not_a_valid_age_value' }
            it { is_expected.not_to be_valid }
          end
        end
      end

      describe 'validating the name step' do
        let(:step) { 'name' }

        before do
          session.age = Age.allowed_values.first
        end

        it 'is not validated' do
          expect(session).to be_valid
        end
      end

      describe 'validating the methodologies step' do
        let(:step) { 'methodologies' }

        before do
          session.age = Age.allowed_values.first
        end

        context 'no methods are selected' do
          it { is_expected.not_to be_valid }
        end

        context 'at least one valid method is selected' do
          before do
            session.methodologies = [:interview]
            session.save
          end
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the recording step' do
        let(:step) { 'recording' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
        end

        context 'no recording methods are selected' do
          it { is_expected.not_to be_valid }
        end

        context 'at least one valid method is selected' do
          before do
            session.recording_methods = [:audio]
            session.save
          end
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the focus step' do
        let(:step) { 'focus' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
          session.recording_methods = [RecordingMethods.allowed_values.first]
        end

        context 'no focus is given' do
          it { is_expected.not_to be_valid }
        end

        context 'research focus is given' do
          before do
            session.focus = 'A nice long focus description'
            session.save
          end
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the researcher step' do
        let(:step) { 'researcher' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
          session.recording_methods = [RecordingMethods.allowed_values.first]
          session.focus = 'A nice long focus'
          session.save
        end

        context 'no details are given' do
          it { is_expected.not_to be_valid }
          it 'has an error for researcher name' do
            expect(session.errors[:researcher_name].length).to eql(1)
          end
          it 'has an error for researcher telephone number' do
            expect(session.errors[:researcher_phone].length).to eql(1)
          end
          it 'has an error for researcher email' do
            expect(session.errors[:researcher_email].length).to eql(1)
          end
        end

        context "all the details are given but the email isn't one" do
          before do
            session.researcher_name  = 'Miss Havisham'
            session.researcher_phone = '12345678'
            session.researcher_email = 'xxxxxxxxx'
            session.save
          end

          it { is_expected.not_to be_valid }
          it 'has an error for email' do
            expect(session.errors[:researcher_email].length).to eql(1)
            expect(session.errors[:researcher_email].first).to match(/is invalid/)
          end
        end

        context 'all the details are given' do
          before do
            session.researcher_name  = 'Miss Havisham'
            session.researcher_phone = '12345678'
            session.researcher_email = 'a@b.com'
            session.save
          end

          it { is_expected.to be_valid }
        end
      end

      describe 'validating the incentive step' do
        let(:step) { 'incentive' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
          session.recording_methods = [RecordingMethods.allowed_values.first]
          session.focus = 'A nice long focus'
          session.researcher_name  = 'Miss Havisham'
          session.researcher_phone = '12345678'
          session.researcher_email = 'a@b.com'
          session.save
        end

        context 'no incentives are given, and no-one cares' do
          it 'sets an appropriate default anyway' do
            expect(session.incentive).to be false
          end
          it { is_expected.to be_valid }
        end

        context 'incentives are on' do
          before do
            session.incentive = true
            session.save
          end

          context 'but no option has been set' do
            it { is_expected.not_to be_valid }
            it 'has an error on payment_type' do
              expect(session.errors[:payment_type].length).to eql(1)
              expect(session.errors[:payment_type].first).to match(/is not included in the list/)
            end
          end

          context 'an option has been set' do
            before do
              session.payment_type = :cash
              session.save
            end
            context 'but no incentive_value has been provided' do
              it { is_expected.not_to be_valid }
              it 'has an error on incentive_value' do
                expect(session.errors[:incentive_value].length).to eql(1)
                expect(session.errors[:incentive_value].first).to match(/can't be blank/)
              end
            end
            context 'and an incentive_value has been provided' do
              before { session.incentive_value = 10.00 }
              it do
                is_expected.to be_valid
              end
            end
          end
        end
      end
    end
  end
end
