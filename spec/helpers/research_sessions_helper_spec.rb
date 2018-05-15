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
          expect(rendered).to eql("/research-sessions/#{slug}/questions/researcher?edit-preview=1")
        end
      end
    end
  end
end
