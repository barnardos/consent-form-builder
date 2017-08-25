require 'rails_helper'

describe ResearchSessionsController, type: :controller do
  render_views

  describe '#start' do
    it 'redirects to the first question' do
      get :start
      expect(response).to redirect_to('/questions/age')
    end
  end

  describe '#show' do
    before do
      get :show, params: { id: template_id }
    end

    context 'when the template exists' do
      context 'the first step, age' do
        let(:template_id) { :age }

        it 'is ok' do
          expect(response).to be_ok
        end
        it 'renders a template for the id given' do
          expect(response.body).to include('What is the age of the research participant?')
        end
        it 'holds the id of a fresh research session' do
          expect(session[:current_research_session_id]).to be_an(Integer)
        end
      end

      context 'methodologies' do
        let(:template_id) { 'methodologies' }

        it 'is ok' do
          expect(response).to be_ok
        end
        it 'renders a template for the id given' do
          expect(response.body).to include('How will you be gathering information?')
        end
      end

      context 'the last step' do
        let(:template_id) { Wicked::FINISH_STEP }

        it 'redirects to the session preview' do
          expect(response).to redirect_to(research_session_preview_path)
        end
      end
    end

    context 'when the template does not exist' do
      let(:template_id) { :i_dont_exist }

      it '404s' do
        expect(response.code).to eql('404')
      end
      it 'says what is missing' do
        expect(response.body).to include('Step "i_dont_exist" not found')
      end
    end
  end

  describe '#update' do
    let(:existing_params) { {} }
    let!(:existing_session) do
      ResearchSession.create(existing_params).tap do |new_session|
        session[:current_research_session_id] = new_session.id
      end
    end
    subject(:research_session) do
      ResearchSession.find(session[:current_research_session_id])
    end

    before do
      put :update, params: params
    end

    context 'there is something useful in the session' do
      let(:params) { { id: 'age', age: 'over18' } }

      it 'updates the current session' do
        expect(research_session.age).to eql('over18')
      end
      it 'redirects to the next question in sequence, which is methodologies' do
        expect(response).to redirect_to('/questions/methodologies')
      end
    end


    context 'the age param is invalid, because it is blank' do
      let(:params) { { id: 'age', age: nil } }

      it 'does not progress to the next step, it asks for age again' do
        expect(response).to be_ok
        expect(response).to render_template(:age)
      end
    end

    context 'accepting methodologies' do
      let(:existing_params) { { age: 'under12' } }
      let(:params) do
        {
          id: 'methodologies',
          'methodologies' => %w(interview usability)
        }
      end

      it 'updates the research session' do
        expect(research_session.methodologies).to eql(%w(interview usability))
      end
    end

    context 'the last step' do
      let(:existing_params) do
        {
          age: 'under12',
          methodologies: %w(interview),
          recording_methods: %w(audio),
          topic: 'Some topic',
          purpose: 'Some purpose',
          researcher_name: 'Alice',
          researcher_phone: '0123456',
          researcher_email: 'a@b.com'
        }
      end

      let(:params) do
        {
          id: 'incentive',
          incentive: '1',
          payment_type: 'cash',
          incentive_value: 10.00
        }
      end

      it 'updates the research session' do
        expect(research_session.incentive).to be true
        expect(research_session.payment_type).to eql('cash')
        expect(research_session.incentive_value).to eql(10.00)
      end

      it 'redirects to the wicked finish step for questions' do
        expect(response).to redirect_to(question_path(Wicked::FINISH_STEP))
      end
    end
  end
end
