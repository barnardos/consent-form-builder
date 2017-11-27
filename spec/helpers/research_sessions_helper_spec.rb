require 'rails_helper'

RSpec.describe ResearchSessionsHelper, :type => :helper do
  include RSpecHtmlMatchers

  describe '#component_params' do
    let(:session) { double('ResearchSession', session_attrs.merge(slug: 'my-session')) }

    before do
      assign(:research_session, session)
    end

    subject(:params) { helper.component_params(*attrs, final_preview: final_preview) }

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
    let(:research_session) { double('ResearchSession') }

    let(:able_to_consent) { true }
    let(:methodology) { 'interview' }
    before do
      allow(research_session).to receive(:able_to_consent?).and_return(able_to_consent)
      assign(:research_session, research_session)
    end

    subject(:translation) { helper.methodology_lookup(methodology) }

    context 'participants are unable to consent' do
      let(:able_to_consent) { false }
      it 'returns a child-appropriate translation' do
        expect(translation).to eql(
          'Your child will be interviewed ' \
          'and asked their views regarding the project being researched.'
        )
      end
    end

    context 'participants are able to consent' do
      let(:able_to_consent) { true }
      it 'returns a adult-appropriate translation' do
        expect(translation).to eql(
          'You will be interviewed ' \
          'and asked your views regarding the project being researched.'
        )
      end
    end

    context 'the research session contains "other"' do
      let(:methodology) { 'other' }
      before { allow(research_session).to receive(:other_methodology).and_return('Reiki') }

      it 'has asked the research session for the translation' do
        expect(translation).to eql('Reiki')
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
