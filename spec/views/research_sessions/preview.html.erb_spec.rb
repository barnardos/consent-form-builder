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
    stub_template 'research_sessions/_progress' => '<%= NOT RENDERED %>'
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

    it 'does not show the date or time' do
      expect(rendered).not_to match('The session is on')
    end

    it 'shows the duration' do
      expect(rendered).to match(/The session will last for.*Three minutes/m)
    end
  end

  context 'no duration is given, but a date is given' do
    let(:extra_attrs) { { when_text: '27th September 2017', duration: nil } }

    it 'shows the date and time' do
      expect(rendered).to match(/The session is on.*27th September 2017/m)
    end

    it 'does not show the duration' do
      expect(rendered).not_to match(/The session will last for/m)
    end
  end

  context 'the participant is able to give consent' do
    let(:able_to_consent) { true }

    it 'phrases blocks using "you"' do
      expect(rendered).to have_content(
        <<~TEXT
          It is important that we test the current and future tools and services
          that we are developing with people like you so that we can make them as
          good as possible.
        TEXT
      )
    end

    it 'phrases React component blocks as "you"' do
      expect(rendered).to have_content('would like you to take part')
    end
  end

  context 'the participant is not able to give consent' do
    let(:able_to_consent) { false }

    it 'phrases blocks using "your child"' do
      expect(rendered).to have_content(
        <<~TEXT
          It is important that we test the current and future tools and services
          that we are developing with people like your child/the child in your
          care so that we can make them as good as possible.
        TEXT
      )
    end

    it 'phrases React component blocks as "your child"' do
      expect(rendered).to have_content('would like your child/the child in your care to take part')
    end
  end
end
