require 'rails_helper'

RSpec.describe ResearchSessionsHelper, :type => :helper do
  include RSpecHtmlMatchers

  describe '#current_step_params' do
    let(:research_session) { double('ResearchSession') }

    before do
      helper.extend Wicked::Controller::Concerns::Steps
      assign(:research_session, research_session)
      allow(helper).to receive(:step).and_return(step)
    end

    context 'a normal step' do
      let(:step) { :topic }

      it 'calls component_params with all the parameters for the current step' do
        expect(helper).to receive(:component_params)
          .with(:topic, :purpose)
          .and_return({})
        helper.current_step_params
      end

      it 'calls unvarying_params for the current step' do
        expect(helper).to receive(:component_params)
          .with(:topic, :purpose)
          .and_return({})
        expect(helper).to receive(:unvarying_params).with(:topic).and_return({})
        helper.current_step_params
      end
    end

    context 'a step with an array param' do
      let(:step) { :recording }

      it 'calls component_params with all the parameters for the current step' do
        expect(helper).to receive(:component_params)
          .with(:other_recording_method, :recording_methods)
          .and_return({})
        helper.current_step_params
      end
    end
  end

  describe '#final_preview_params' do
    context 'a normal step' do
      let(:step) { :topic }
      let(:research_session) { double('ResearchSession') }

      before do
        assign(:research_session, research_session)
      end

      it 'calls component_params with all the parameters for the current step' do
        expect(helper).to receive(:component_params)
          .with(:topic, :purpose, final_preview: true)
          .and_return({})
        helper.final_preview_params(step)
      end
    end

    context 'a step with an array param' do
      let(:step) { :recording }
      let(:research_session) { double('ResearchSession').as_null_object }

      before do
        assign(:research_session, research_session)
      end

      it 'calls component_params with all the parameters for the current step' do
        allow(helper).to receive(:component_params)
          .with(:other_recording_method, :recording_methods, final_preview: true)
          .and_return({})
        helper.final_preview_params(step)
      end

      it 'calls unvarying_params for the current step' do
        allow(helper).to receive(:component_params).and_return({})
        expect(helper).to receive(:unvarying_params).with(:recording).and_return({})
        helper.final_preview_params(step)
      end
    end
  end

  describe '#unvarying_params' do
    subject(:unvarying_params) { helper.send(:unvarying_params, step) }

    context 'the step has no unvarying params that would repeat across live/final preview' do
      let(:step) { :researcher }
      it { is_expected.to be_empty }
    end

    context 'the step has unvarying params that would repeat across live/final preview' do
      let(:step) { :topic }
      it { is_expected.to have_key(:labels) }
    end

    context 'the step has params that should default to no consent' do
      let(:step) { :storing }
      it { is_expected.to have_key(:shared_with_sentences) }

      it 'defaults anonymised to unable_to_consent?' do
        expect(unvarying_params.dig(:shared_with_sentences, :anonymised)).to include(
          'your child/the child in your care will not be identifiable'
        )
      end
    end
  end

  describe '#component_params' do
    let(:session) { double('ResearchSession', session_attrs.merge(slug: 'my-session')) }

    before do
      assign(:research_session, session)
    end

    subject(:params) { helper.send(:component_params, *attrs, final_preview: final_preview) }

    context 'all params exist on the object' do
      let(:session_attrs)  { { researcher_name: 'Joe', researcher_job_title: 'Janitor' } }
      let(:attrs)          { session_attrs.keys }

      context 'final_preview is false' do
        let(:final_preview)  { false }

        it 'has no editLinks' do
          expect(params[:editLinks]).to be_empty
        end

        it 'has finalPreview as provided' do
          expect(params[:finalPreview]).to eql(false)
        end

        it 'has the values for each' do
          expect(params[:researcher_name]).to eql(session.researcher_name)
          expect(params[:researcher_job_title]).to eql(session.researcher_job_title)
        end
      end

      context 'final_preview is true' do
        let(:final_preview)  { true }

        it 'makes rails-routed editLinks for each' do
          expect(params[:editLinks]).to eql(
            researcher_name:
              '/research-sessions/my-session/questions/researcher?edit-preview=1',
            researcher_job_title:
              '/research-sessions/my-session/questions/researcher?edit-preview=1'
          )
        end

        it 'has finalPreview as provided' do
          expect(params[:finalPreview]).to eql(true)
        end

        it 'has the values for each' do
          expect(params[:researcher_name]).to eql(session.researcher_name)
          expect(params[:researcher_job_title]).to eql(session.researcher_job_title)
        end
      end
    end
  end

  describe '#edit_link_for' do
    let(:session) { double('ResearchSession') }
    let(:block) { nil }
    let(:slug) { 'foobar' }

    before do
      allow(session).to receive(attr).and_return('Some attr value')
      allow(session).to receive(attr).with(:i_dont_exist).and_raise(NameError)
      allow(session).to receive(:slug).and_return(slug)
      @research_session = session
    end

    subject(:rendered) { helper.edit_link_for(attr, &block) }

    context "the attr isn't on the session" do
      let(:attr) { :i_dont_exist }
      it 'raises a KeyError' do
        expect { helper.edit_link_for(attr) }.to raise_error(KeyError, /i_dont_exist/)
      end
    end

    context 'the attr is one we know about' do
      let(:attr) { :researcher_name }

      context 'a researcher attribute' do
        it 'links to the researcher step' do
          expect(rendered).to have_tag(
            'a', text: /Some attr value/,
                 with: { href: "/research-sessions/#{slug}/questions/researcher?edit-preview=1" }
          )
        end
      end

      context 'a custom block is given for content' do
        let(:block) { -> { 'I learned it in a block' } }

        it 'uses the block content' do
          expect(rendered).to have_tag('a', text: /I learned it in a block/)
        end
      end
    end
  end

  describe '#methodology_lookup' do
    subject(:translation) { helper.methodology_lookup(methodology) }

    context 'is a non-other methodology' do
      let(:methodology) { 'interview' }
      it { is_expected.to eql('a one-on-one interview') }
    end

    context 'is an Other methodology' do
      let(:research_session) do
        double('ResearchSession', other_methodology: 'A.N. Other Methodology')
      end

      before do
        assign(:research_session, research_session)
      end

      let(:methodology) { 'other' }
      it 'is equal to the "other" methodology on the research session' do
        is_expected.to eql(research_session.other_methodology)
      end
    end
  end

  describe '#shared_with_lookup' do
    let(:research_session) { double('ResearchSessionPresenter', able_to_consent?: false) }

    before { assign(:research_session, research_session) }

    subject { helper.shared_with_lookup(shared_with) }

    context 'a static string' do
      let(:shared_with) { :team }

      it {
        is_expected.to include(
          'will be shared no more widely than the team undertaking the research'
        )
      }
    end

    context 'a consent-sensitive string' do
      let(:shared_with) { :anonymised }

      context 'not able_to_consent?' do
        it {
          is_expected.to include(
            'Therefore, your child/the child in your care will not be identifiable'
          )
        }
      end

      context 'Actually able_to_consent?' do
        let(:research_session) { double('ResearchSessionPresenter', able_to_consent?: true) }
        it { is_expected.to include('Therefore, you will not be identifiable') }
      end
    end
  end
end
