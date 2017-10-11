require 'rails_helper'

RSpec.describe ResearchSessionsHelper, :type => :helper do
  include RSpecHtmlMatchers

  describe '#edit_link_for' do
    let(:session) { double('ResearchSession') }
    let(:block) { nil }

    before do
      allow(session).to receive(attr).and_return('Some attr value')
      allow(session).to receive(attr).with(:i_dont_exist).and_raise(NameError)
      allow(session).to receive(:id).and_return(1234)
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
            'a', text: /Some attr value/, with: { href: '/research-sessions/1234/questions/researcher?edit-preview=1' }
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
end
