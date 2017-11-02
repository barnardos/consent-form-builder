require 'rails_helper'

describe ResearchSessionsController, type: :controller do
  describe '#create' do
    context 'with no name' do
      it 'fails validation and returns to new' do
        post :create, params: { research_session: { name: nil } }
        expect(response).to render_template(:new)
      end
    end

    context 'with a valid name' do
      it 'redirects to the first question' do
        post :create, params: { research_session: { name: 'My session' } }
        research_session = ResearchSession.first
        expect(response).to \
          redirect_to(research_session_question_path(research_session.slug, id: 'researcher'))
      end
    end
  end
end
