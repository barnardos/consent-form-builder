require 'rails_helper'

RSpec.describe ResearchSession, type: :model do
  describe 'slugs from names' do
    let(:name) { 'Bullying in schools' }

    subject(:slug) do
      session = ResearchSession.new(name: name)
      expect(session).to be_valid
      session.slug
    end

    context 'there is no name clash' do
      it 'is dasherized' do
        expect(slug).to eql('bullying-in-schools')
      end
    end

    context 'a session with the same slug already exists' do
      before { create :research_session, name: 'Bullying in schools' }
      it 'disambiguates with a UUID' do
        uuid = '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
        expect(slug).to match(Regexp.new("^bullying-in-schools-#{uuid}$"))
      end
    end
  end

  describe 'partial validation on status' do
    subject(:session) { ResearchSession.new }

    it 'instantiates new ResearchSessions with a status of new' do
      expect(session.status).to eql('new')
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
        session.status = step
        attrs = attributes_for(:research_session, "step_#{step}".to_sym)
        session.assign_attributes(attrs.merge(set_attrs))
        session.validate
      end

      describe 'validating the researcher step' do
        context 'no details are given' do
          before do
            session.status = :researcher
            session.validate
          end

          it { is_expected.not_to be_valid }
          it 'has an error for researcher name' do
            expect(session.errors[:researcher_name].length).to eql(1)
          end
          it 'has an error for researcher email' do
            expect(session.errors[:researcher_email].length).to eql(1)
          end
        end

        context "all the details are given but the email isn't valid" do
          let(:step) { :researcher }
          let(:set_attrs) { { researcher_email: 'xxxxxxxx' } }

          it { is_expected.not_to be_valid }
          it 'has an error for email' do
            expect(session.errors[:researcher_email].length).to eql(1)
            expect(session.errors[:researcher_email].first).to match(/is invalid/)
          end
        end

        context 'all the details for "new" are given' do
          it { is_expected.to be_valid }
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
