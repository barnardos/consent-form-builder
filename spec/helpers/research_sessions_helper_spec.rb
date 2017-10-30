require 'rails_helper'

RSpec.describe ResearchSessionsHelper, :type => :helper do
  include RSpecHtmlMatchers

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
end
