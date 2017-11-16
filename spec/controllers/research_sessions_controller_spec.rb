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

  describe '#new' do
    before { get :new, params: params }

    context 'there is no query string' do
      let(:params) { {} }

      it 'just renders the new form' do
        expect(response).to render_template(:new)
      end
    end

    context 'we are creating a copy from an existing session' do
      let(:existing_session) { create :research_session, :previewable }
      let(:params) { { from_existing: existing_session.slug } }

      it 'renders a different kind of new form tailored to creating a copy' do
        expect(response).to render_template(:create_a_copy)
      end

      it 'proposes a name' do
        expect(assigns(:research_session).name).to eql("#{existing_session.name} (copy)")
      end
    end
  end

  describe '#create_a_copy' do
    before do
      post :create_a_copy, params: params
    end

    context 'there is no existing session' do
      let(:params) do
        { research_session_id: 'i-dont-exist', research_session: { name: 'I do not exist' } }
      end

      it '404s' do
        expect(response.status).to eql(404)
      end
    end

    context 'there is an existing session' do
      let(:new_session_name) { 'Here is a new name' }
      let(:new_session_slug) { 'here-is-a-new-name' }

      let(:params) do
        {
          research_session_id: existing_session.slug,
          research_session: { name: new_session_name }
        }
      end

      context 'which is not yet previewable' do
        let(:existing_session) { create :research_session, :step_researcher }

        it 'should never get here (the copy button should not exist) and 400s' do
          expect(response.status).to eql(400)
        end
      end

      context 'There is an existing valid session' do
        let(:existing_session) { create :research_session, :previewable }

        it 'creates a copy of the session with the name given' do
          new_session = ResearchSession.find_by!(slug: new_session_slug)
          expect(new_session.name).to eql(new_session_name)
        end

        it 'redirects to the preview of the newly-named session' do
          expect(response).to redirect_to(
            research_session_preview_path(research_session_id: new_session_slug)
          )
        end
      end
    end
  end
end
