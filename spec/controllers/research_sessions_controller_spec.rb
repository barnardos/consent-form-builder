require 'rails_helper'

describe ResearchSessionsController, type: :controller do
  render_views

  describe '#create' do
    it 'redirects to the first question' do
      post :create
      research_session = ResearchSession.first
      expect(response).to \
        redirect_to(research_session_question_path(research_session, id: 'researcher'))
    end
  end

  describe '#show' do
    let(:existing_session) { ResearchSession.create }
    subject(:research_session) do
      ResearchSession.find(existing_session.id)
    end

    before do
      get :show, params: { research_session_id: research_session.id, id: template_id }
    end

    context 'when the template exists' do
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
    let(:existing_session) { ResearchSession.create(existing_params) }
    subject(:research_session) do
      ResearchSession.find(existing_session.id)
    end

    before do
      put :update, params: params
    end

    context 'accepting methodologies' do
      let(:existing_params) do
        {
          age: 'under18',
          researcher_name: 'Alice',
          researcher_phone: '0123456',
          researcher_email: 'a@b.com',
          topic: 'some topic',
          purpose: 'some purppose'
        }
      end
      let(:params) do
        {
          research_session_id: existing_session.id,
          id: 'methodologies',
          research_session: { 'methodologies' => %w[interview usability] }
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
          researcher_email: 'a@b.com',
          shared_with: 'team',
          shared_duration: '1 Day',
          shared_use: 'How to help people more'
        }
      end

      let(:params) do
        {
          research_session_id: existing_session.id,
          id: 'incentive',
          research_session: {
            incentive: true,
            payment_type: 'cash',
            incentive_value: 10.00
          }
        }
      end

      it 'updates the research session' do
        expect(research_session.incentive).to be true
        expect(research_session.payment_type).to eql('cash')
        expect(research_session.incentive_value).to eql(10.00)
      end

      it 'redirects to the wicked finish step for questions' do
        expect(response).to redirect_to(
          research_session_question_path(
            research_session_id: existing_session.id,
            id: Wicked::FINISH_STEP
          )
        )
      end
    end
  end
end
