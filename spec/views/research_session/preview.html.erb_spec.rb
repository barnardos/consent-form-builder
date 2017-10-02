require 'rails_helper'

describe 'research_sessions/preview' do
  let(:research_session) do
    build_stubbed :research_session, :previewable, extra_attrs
  end

  before do
    assign(:research_session, ResearchSessionPresenter.new(research_session))
    stub_template 'research_sessions/_progress' => '<%= NOT RENDERED %>'
    render
  end
  context 'no date or duration is given' do
    let(:extra_attrs) { { start_datetime: nil, duration: nil } }

    it 'does not show the date or time' do
      expect(rendered).not_to include('When is the session and what should I bring?')
    end
  end

  context 'no date is given, but a duration is given' do
    let(:extra_attrs) { { start_datetime: nil, duration: 'Three minutes' } }

    it 'does not show the date or time' do
      expect(rendered).not_to match('The session is on')
    end

    it 'shows the duration' do
      expect(rendered).to match(/The session will last for.*Three minutes/m)
    end
  end

  context 'no duration is given, but a date is given' do
    let(:extra_attrs) { { start_datetime: DateTime.parse('27 Sep 2017'), duration: nil } }

    it 'shows the date and time' do
      expect(rendered).to match(/The session is on.*September 27, 2017/m)
    end

    it 'does not show the duration' do
      expect(rendered).not_to match(/The session will last for/m)
    end
  end

  context 'the participant is able to give consent' do
    let(:extra_attrs) { { age: 'over18' } }

    it 'phrases blocks using "you"' do
      expect(rendered).to have_content(
        <<~TEXT
          Taking part is entirely voluntary -
          it is up to you to decide whether or not you should take part.
          If you decide you should take part you do not have to answer
          questions you do not want to answer. You can also change your mind about taking part
          at any time and withdraw without giving a reason.
        TEXT
      )
    end
  end

  context 'the participant is not able to give consent' do
    let(:extra_attrs) { { age: 'under18' } }

    it 'phrases blocks using "your child"' do
      expect(rendered).to have_content(
        <<~TEXT
          Taking part is entirely voluntary -
          it is up to you to decide whether or not your child/the child in your care should take part.
          If you decide your child/the child in your care should take part they do not have to answer
          questions they do not want to answer. They can also change their mind about taking part
          at any time and withdraw without giving a reason.
        TEXT
      )
    end
  end
end
