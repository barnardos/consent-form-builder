require 'rails_helper'

RSpec.describe ResearchSession, type: :model do
  describe 'partial validation on status' do
    subject(:session) { ResearchSession.new }

    it 'instantiates new ResearchSessions with a status of new' do
      expect(session.status).to eql('new')
    end

    it 'allows us to create a session with no details' do
      new_session = ResearchSession.create
      expect(new_session).to be_valid
      expect(new_session).to be_persisted
    end

    describe '#un/able_to_consent?' do
      before { session.age = age }
      context 'is too young' do
        let(:age) { 'under12' }
        it { is_expected.not_to be_able_to_consent }
        it { is_expected.to be_unable_to_consent }
      end
      context 'is old enough' do
        let(:age) { 'over18' }
        it { is_expected.to be_able_to_consent }
        it { is_expected.not_to be_unable_to_consent }
      end
    end

    describe '#reached_step?' do
      it 'passes through to Steps' do
        steps_spy = spy('Steps')
        allow(ResearchSession::Steps).to receive(:instance).and_return(steps_spy)
        session.reached_step?(:methodologies)
        expect(steps_spy).to have_received(:reached_step?)
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

      describe 'validating the methodologies step' do
        let(:step) { 'methodologies' }

        before do
          session.age = Age.allowed_values.first
        end

        context 'no methodologies are selected' do
          it { is_expected.not_to be_valid }
        end

        context 'at least one valid methodology is selected' do
          before do
            session.methodologies = [:interview]
            session.save
          end
          it { is_expected.to be_valid }
        end

        context 'the "other" methodology is selected' do
          before do
            session.methodologies = [:other]
            session.other_methodology = other_methodology
            session.save
          end

          context 'other methodology is blank' do
            let(:other_methodology) { nil }
            it { is_expected.not_to be_valid }
            it 'has one error on other_methodology' do
              expect(session.errors[:other_methodology].length).to eql(1)
              expect(session.errors[:other_methodology].first).to eql("can't be blank")
            end
          end
          context 'other methodology is supplied' do
            let(:other_methodology) { 'Another methodology' }
            it { is_expected.to be_valid }
          end
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

        context 'the "other" recording methods is selected' do
          before do
            session.recording_methods = [:other]
            session.other_recording_method = other_recording_method
            session.save
          end

          context 'other methodology is blank' do
            let(:other_recording_method) { nil }
            it { is_expected.not_to be_valid }
            it 'has one error on other_recording_method' do
              expect(session.errors[:other_recording_method].length).to eql(1)
              expect(session.errors[:other_recording_method].first).to eql("can't be blank")
            end
          end
          context 'other methodology is supplied' do
            let(:other_recording_method) { 'Another methodology' }
            it { is_expected.to be_valid }
          end
        end
      end

      describe 'validating the topic step' do
        let(:step) { 'topic' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
          session.recording_methods = [RecordingMethods.allowed_values.first]
        end

        context 'no topic is given' do
          it { is_expected.not_to be_valid }
        end

        context 'research topic is given' do
          before do
            session.topic = 'A nice long topic description'
            session.save
          end
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the purpose step' do
        let(:step) { 'purpose' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
          session.recording_methods = [RecordingMethods.allowed_values.first]
          session.topic = 'A nice long topic description'
        end

        context 'no purpose is given' do
          it { is_expected.not_to be_valid }
        end

        context 'research purpose is given' do
          before do
            session.purpose = 'A nice long puropose description'
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
          session.topic = 'A nice long topic description'
          session.purpose = 'A nice long puropose description'
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

      describe 'validating the data step' do
        let(:step) { 'data' }

        before do
          session.age = Age.allowed_values.first
          session.methodologies = [Methodologies.allowed_values.first]
          session.recording_methods = [RecordingMethods.allowed_values.first]
          session.topic = 'A nice long topic description'
          session.purpose = 'A nice long puropose description'
          session.researcher_name  = 'Miss Havisham'
          session.researcher_phone = '12345678'
          session.researcher_email = 'a@b.com'
          session.save
        end

        context 'no details are give' do
          it { is_expected.not_to be_valid }
          it 'has an error for shared with' do
            expect(session.errors[:shared_with].length).to eql(1)
          end
          it 'has an error for shared duration' do
            expect(session.errors[:shared_duration].length).to eql(1)
          end
          it 'has an error for use' do
            expect(session.errors[:shared_use].length).to eql(1)
          end
        end

        context 'all the details are given but the team in invalid' do
          before do
            session.shared_with = 'nobody'
            session.shared_duration = '1 week'
            session.shared_use = 'xxxxxxxxx'
            session.save
          end

          it { is_expected.not_to be_valid }
          it 'has an error for shared with' do
            expect(session.errors[:shared_with].length).to eql(1)
          end
        end

        context 'all the details are given' do
          before do
            session.shared_with = SharedWith.allowed_values.first
            session.shared_duration = '1 week'
            session.shared_use = 'xxxxxxxxx'
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
          session.topic = 'A nice long topic description'
          session.purpose = 'A nice long puropose description'
          session.researcher_name  = 'Miss Havisham'
          session.researcher_phone = '12345678'
          session.researcher_email = 'a@b.com'
          session.shared_with = SharedWith.allowed_values.first
          session.shared_duration = '1 week'
          session.shared_use = 'xxxxxxxxx'
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
