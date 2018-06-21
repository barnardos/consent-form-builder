require 'rails_helper'

describe 'research_sessions/preview' do
  let(:extra_attrs)     { {} }
  let(:able_to_consent) { false }

  let(:research_session) do
    build_stubbed(:research_session, :previewable, extra_attrs).tap(&:set_slug_from_name!)
  end

  let(:presenter) do
    ResearchSessionPresenter.new(
      research_session,
      able_to_consent: able_to_consent
    )
  end

  before do
    assign(:research_session, presenter)
    view.lookup_context.view_paths.unshift 'frontend/'
    render
  end
  context 'no date or duration is given' do
    let(:extra_attrs) { { when_text: nil, duration: nil } }

    it 'does not show the date or time' do
      expect(rendered).not_to include('When is the session and what should I bring?')
    end
  end

  context 'no date is given, but a duration is given' do
    let(:extra_attrs) { { when_text: nil, duration: 'Three minutes' } }

    it 'shows the duration' do
      expect(rendered).to match(/Duration.*Three minutes/m)
    end
  end

  context 'no duration is given, but a date is given' do
    let(:extra_attrs) { { when_text: '27th September 2017', duration: nil } }

    it 'shows the date and time' do
      expect(rendered).to match(/When.*27th September 2017/m)
    end

    it 'does not show the duration' do
      expect(rendered).not_to have_content('Duration')
    end
  end

  context 'the participant is able to give consent' do
    let(:able_to_consent) { true }

    it 'phrases blocks using "you"' do
      expect(rendered).to have_content(
        <<~TEXT
          Barnardo’s would like you to be part of this research.
        TEXT
      )
    end
  end

  context 'the participant is not able to give consent' do
    let(:able_to_consent) { false }

    it 'phrases blocks using "your child"' do
      expect(rendered).to have_content(
        <<~TEXT
          Barnardo’s would like your child/the child in your care to be part of this research.
        TEXT
      )
    end
  end

  context 'there are no incentives, expenses or where_when details' do
    let(:extra_attrs) do
      {
        incentives_enabled: false,
        expenses_enabled: false,
        where_when_enabled: false
      }
    end

    it 'has no "Session details" section' do
      expect(rendered).not_to have_selector('h3', text: 'Session details')
    end
  end
end
