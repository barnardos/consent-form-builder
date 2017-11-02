require 'rails_helper'

RSpec.describe ResearchSessions::QuestionsController, type: :controller do
  describe '#show' do
    let(:existing_session) { create :research_session }
    subject(:research_session) do
      ResearchSession.find(existing_session.id)
    end

    before do
      get :show, params: { research_session_id: research_session.slug, id: template_id }
    end

    context 'when the template exists' do
      context 'methodologies' do
        let(:template_id) { 'methodologies' }

        it 'is ok' do
          expect(response).to be_ok
        end
        it 'renders a template for the id given' do
          expect(response.body).to render_template('methodologies')
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
    let(:existing_session) { create(:research_session, :"step_#{existing_step}") }
    subject(:research_session) do
      ResearchSession.find(existing_session.id)
    end

    before do
      put :update, params: params
    end

    context 'accepting methodologies' do
      let(:existing_step) { :topic }
      let(:params) do
        {
          research_session_id: existing_session.slug,
          id: 'methodologies',
          research_session: { 'methodologies' => ['', 'interview', 'usability'] }
        }
      end

      it 'updates the research session, stripping the blank' do
        expect(research_session.methodologies).to eql(%w[interview usability])
      end
    end

    context 'accepting recording methods' do
      let(:existing_step) { :methodologies }
      let(:params) do
        {
          research_session_id: existing_session.slug,
          id: 'recording',
          research_session: { 'recording_methods' => ['', 'audio', 'video'] }
        }
      end

      it 'updates the research session, stripping the blank' do
        expect(research_session.recording_methods).to eql(%w[audio video])
      end
    end

    context 'returning to a previous step' do
      let(:existing_step) { :incentives }
      let(:params) do
        {
          research_session_id: existing_session.slug,
          id: 'methodologies',
          research_session: { 'methodologies' => ['', 'interview', 'usability'] }
        }
      end

      it 'keeps the research session at the step it had reached' do
        expect(research_session.status).to eql('incentives')
      end
    end

    context 'editing a previous step and returning directly to preview' do
      let(:existing_step) { :incentives }
      let(:new_phone_number) { '01010101010101' }
      let(:params) do
        {
          research_session_id: existing_session.slug,
          id: 'researcher',
          research_session: { 'researcher_phone' => new_phone_number },
          'edit-preview' => '1'
        }
      end

      it 'updates the research session' do
        expect(research_session.researcher_phone).to eql(new_phone_number)
      end

      it 'returns to the preview' do
        expect(response).to redirect_to(
          research_session_preview_path(existing_session)
        )
      end
    end

    context 'the last step' do
      let(:existing_step) { :storing }

      let(:params) do
        {
          research_session_id: existing_session.slug,
          id: 'incentives',
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
            research_session_id: existing_session.slug,
            id: Wicked::FINISH_STEP
          )
        )
      end
    end
  end
end
