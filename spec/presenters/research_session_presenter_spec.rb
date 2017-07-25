require 'rails_helper'

RSpec.describe ResearchSessionPresenter do
  include RSpecHtmlMatchers

  let(:research_session) { spy('ResearchSession') }

  subject(:presenter) { ResearchSessionPresenter.new(research_session) }

  it 'holds on to the research session' do
    expect(presenter.research_session).to eql(research_session)
  end

  [:age, :focus, :researcher_name, :researcher_other_name,
   :researcher_email, :researcher_phone].each do |method|
    it "delegates #{method} to the research_session" do
      presenter.send method
      expect(research_session).to have_received(method)
    end
  end

  describe '#methodology_list' do
    let(:methodologies) { [:interview, :usability] }
    before do
      allow(research_session).to receive(:age).and_return(age)
      allow(research_session).to receive(:methodologies).and_return(methodologies)
    end

    subject(:list) { presenter.methodology_list }

    context 'the research session is targeted at children' do
      let(:age) { 'under12' }
      it 'has as many paragraphs as there are methodologies' do
        expect(list).to have_tag('p', count: 2)
      end
      it 'assembles a child-appropriate list of methodology segments' do
        expect(list).to include('Your child will be interviewed')
        expect(list).to include('Your child will be asked')
      end
      it 'is html_safe' do
        expect(list).to be_html_safe
      end
    end

    context 'the research session is targeted at adults' do
      let(:age) { 'over18' }
      it 'has as many paragraphs as there are methodologies' do
        expect(list).to have_tag('p', count: 2)
      end
      it 'assembles an adult-appropriate list of methodology segments' do
        expect(list).to include('You will be interviewed')
        expect(list).to include('You will be asked')
      end
    end
  end
end
