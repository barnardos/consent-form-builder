class QuestionsController < ApplicationController
  rescue_from ActionView::MissingTemplate do
    render status: 404,
           plain: %(Question "#{params[:id]}" not found)
  end

  def index
  end

  def start
    redirect_to(first_question_path)
  end

  def show
    @template_name = params[:id]
    @session_data = session_data
  end

  def create
    session_data.reverse_merge!(question_params)
    redirect_to(question_path(id: Question.next(params[:id])))
  end

private
  def session_data
    session[:data] ||= {}
  end

  def first_question_path
    question_path(id: Question::ORDERED_KEYS.first)
  end

  def question_params
    params.permit(Question::PARAM_KEYS)
  end
end

