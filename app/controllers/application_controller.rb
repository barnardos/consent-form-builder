class ApplicationController < ActionController::Base
  helper Barnardos::ActionView::FormHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  protect_from_forgery with: :exception

  prepend_view_path Rails.root.join('frontend')

  def render_404
    redirect_to '/404'
  end
end
