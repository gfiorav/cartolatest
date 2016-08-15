require 'carto_latest/metrics'

class MapsController < ApplicationController
  before_filter :authorize, only: :create
  before_filter :destroy_if_earlier_exists, only: :create

  after_filter :remove_old_maps

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  MAX_MAPS = 50

  def index
    @maps = Map.order(created_at: :desc).take(MAX_MAPS)
  end

  def create
    Map.new(map_params).save!

    render json: 'Thanks for sharing!', status: :ok
  end

  private

    def authorize
      app_id = request.headers['X-App-ID']
      app_key = request.headers['X-App-Key']

      unless App.find_by!(app_id: app_id).authorized?(app_key)
        render status: :unauthorized
      end
    end

    def destroy_if_earlier_exists
      map = Map.find_by(visualization_id: map_params[:visualization_id])

      published_at = map_params[:published_at]
      map.destroy if map && published_at && map.published_at < published_at
    end

    def map_params
      params.permit(:author, :organization, :visualization_id, :privacy, :published_at)
    end

    def remove_old_maps
      (Map.all - Map.order(created_at: :desc).take(MAX_MAPS)).each(&:destroy)
    end
end
