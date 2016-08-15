class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def not_found
    render json: { exception: exception }, status: :not_found
  end

  def unprocessable_entity
    render json: exception.record.errors, status: :unprocessable_entity
  end
end
