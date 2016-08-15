require 'carto_latest/metrics'

class MapsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  before_filter :authorize, only: :create
  before_filter :destroy_if_earlier_exists, only: :create
  after_filter :remove_old_maps

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { exception: exception }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: exception.record.errors, status: :unprocessable_entity
  end

  MAX_MAPS = 50

  def index
    @maps = Map.order(created_at: :desc).take(MAX_MAPS)
  end

  def create
    Map.new(map_params).save!

    render json: 'Thanks for posting!', status: :ok
  end

  private

    def authorize
      name = request.headers['X-App-Name']
      token = request.headers['X-App-Token']

      unless App.find_by!(name: name).authorized?(token)
        render status: :unauthorized
      end
    end

    def destroy_if_earlier_exists
      map = Map.find_by(visualization_id: map_params[:visualization_id])

      published_at = map_params[:published_at]
      map.destroy if map && published_at && map.published_at < published_at
    end

    def map_params
      params.permit(:username, :organization, :visualization_id, :privacy, :published_at)
    end

    def remove_old_maps
      (Map.all - Map.order(created_at: :desc).take(MAX_MAPS)).each(&:destroy)
    end
end
