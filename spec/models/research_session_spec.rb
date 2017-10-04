require 'rails_helper'

RSpec.describe ResearchSession, type: :model do
  describe 'partial validation on status' do
    subject(:session) { ResearchSession.new }

    it 'instantiates new ResearchSessions with a status of new' do
      expect(session.status).to eql('new')
    end

    describe '#un/able_to_consent?' do
      before { session.age = age }
      context 'is too young' do
        let(:age) { 'under18' }
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
      let(:step)      { :new }
      let(:set_attrs) { {} }

      before do
        if step != :new
          attrs = attributes_for(:research_session, :"step_#{step}")
          session.assign_attributes(attrs.merge(set_attrs))
        end
        session.validate
      end

      describe 'validating the researcher step' do
        before do
          session.status = :researcher
        end

        context 'no researchers are given' do
          before do
            session.researchers = []
            session.validate
          end

          it { is_expected.not_to be_valid }
          it 'has an error for the researchers collection' do
            expect(session.errors[:researchers].first).to match(/can't be blank/)
          end
        end

        context 'a researcher is given with missing details' do
          before do
            session.researchers.build do |researcher|
              researcher.researcher_name = ''
              researcher.researcher_email = ''
            end
            session.validate
          end

          it { is_expected.not_to be_valid }
          it 'errors on the nested researcher attributes' do
            expect(session.errors['researchers.researcher_name'].first).to match(/can't be blank/)
            expect(session.errors['researchers.researcher_email'].first).to match(/is invalid/)
          end
        end
      end

      describe 'validating the topic step' do
        let(:step) { :topic }

        context 'no topic is given' do
          let(:set_attrs) { { topic: nil } }
          it { is_expected.not_to be_valid }
        end

        context 'research topic is given' do
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the purpose step' do
        let(:step) { :purpose }

        context 'no purpose is given' do
          let(:set_attrs) { { purpose: nil } }
          it { is_expected.not_to be_valid }
        end

        context 'research purpose is given' do
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the methodologies step' do
        let(:step) { :methodologies }

        context 'no methodologies are selected' do
          let(:set_attrs) { { methodologies: nil } }
          it { is_expected.not_to be_valid }
        end

        context 'at least one valid methodology is selected' do
          it { is_expected.to be_valid }
        end

        context 'the "other" methodology is selected' do
          let(:set_attrs) { { methodologies: [:other], other_methodology: other_methodology } }

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
        let(:step) { :recording }

        context 'no recording methods are selected' do
          let(:set_attrs) { { recording_methods: nil } }
          it { is_expected.not_to be_valid }
        end

        context 'at least one valid method is selected' do
          it { is_expected.to be_valid }
        end

        context 'the "other" recording methods is selected' do
          let(:set_attrs) do
            {
              recording_methods: [:other],
              other_recording_method: other_recording_method
            }
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

      describe 'validating the data step' do
        let(:step) { :data }

        context 'no details are given' do
          let(:set_attrs) { { shared_with: nil, shared_duration: nil, shared_use: nil } }
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

        context 'all the details are given but the shared_with team is invalid' do
          let(:set_attrs) { { shared_with: 'nobody_useful' } }

          it { is_expected.not_to be_valid }
          it 'has an error for shared with' do
            expect(session.errors[:shared_with].length).to eql(1)
            expect(session.errors[:shared_with].first).to match(/is not included in the list/)
          end
        end

        context 'all the details are given' do
          it { is_expected.to be_valid }
        end
      end

      describe 'validating the incentive step' do
        let(:step) { :incentive }

        context 'no incentives are given, and no-one cares' do
          let(:set_attrs) { { incentive: nil } }

          it { is_expected.to be_valid }
        end

        context 'incentives are on' do
          context 'but no option has been set' do
            let(:set_attrs) { { payment_type: nil } }

            it { is_expected.not_to be_valid }
            it 'has an error on payment_type' do
              expect(session.errors[:payment_type].length).to eql(1)
              expect(session.errors[:payment_type].first).to match(/is not included in the list/)
            end
          end

          context 'an option has been set' do
            context 'but no incentive_value has been provided' do
              let(:set_attrs) { { incentive_value: nil } }

              it { is_expected.not_to be_valid }
              it 'has an error on incentive_value' do
                expect(session.errors[:incentive_value].length).to eql(1)
                expect(session.errors[:incentive_value].first).to match(/can't be blank/)
              end
            end

            context 'and an incentive_value has been provided' do
              it { is_expected.to be_valid }
            end
          end
        end
      end
    end
  end
end
