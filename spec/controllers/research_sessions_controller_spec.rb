require 'rails_helper'

describe ResearchSessionsController, type: :controller do
  render_views

  describe '#start' do
    it 'redirects to the first question' do
      get :start
      expect(response).to redirect_to('/research_sessions/age')
    end
  end

  describe '#show' do
    before do
      get :show, params: { id: template_id }
    end

    context 'when the template exists' do
      context 'age' do
        let(:template_id) { :age }

        it 'is ok' do
          expect(response).to be_ok
        end
        it 'renders a template for the id given' do
          expect(response.body).to include('What is the age of the research participant?')
        end
      end

      context 'name' do
        let(:template_id) { 'name' }

        it 'is ok' do
          expect(response).to be_ok
        end
        it 'renders a template for the id given' do
          expect(response.body).to include('What is the name of the research participant?')
        end
      end
    end

    context 'when the template does not exist' do
      let(:template_id) { :i_dont_exist }

      it '404s' do
        expect(response.code).to eql('404')
      end
      it 'says what is missing' do
        expect(response.body).to include('ResearchSession "i_dont_exist" not found')
      end
    end
  end

  describe '#update' do
    subject(:session_data) { session[:data] }

    before do
      post :create, params: params
    end

    context 'there is something useful in the session' do
      let(:params) { { id: 'age', age: 'over18', bobbins: 'wont-show-up' } }

      it 'merges the useful stuff' do
        expect(session_data['age']).to eql('over18')
      end
      it 'does not merge stuff we are not interested in' do
        expect(session_data['bobbins']).to be_nil
      end
      it 'redirects to the next question in sequence, which is name' do
        expect(response).to redirect_to('/research_sessions/name')
      end
    end
  end
end
