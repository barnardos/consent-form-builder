class ApplicationController < ActionController::Base
  helper Barnardos::ActionView::FormHelper

  protect_from_forgery with: :exception
end
