class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def record_not_found
    render json: { exception: exception }, status: :not_found
  end

  def record_invalid
    render json: exception.record.errors, status: :unprocessable_entity
  end
end
