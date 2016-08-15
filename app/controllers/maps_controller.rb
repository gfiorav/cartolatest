require 'carto_latest/metrics'

class MapsController < ApplicationController
  before_filter :fetch_latest_published, only: :index
  after_filter :remove_old_maps, only: :index

  MAPS = 16

  MIN_TIME_FOR_REFRESH = 5.minutes

  def index
    @maps = Map.order(created_at: :desc).take(MAPS)
  end

  private

    def fetch_latest_published
      new_maps = CartoLatest::Metrics.new.latest_published.map { |event| Map.from_event(event) }

      new_maps.each(&:save)
    end

    def remove_old_maps
      (Map.all - Map.order(created_at: :desc).take(MAPS)).each(&:destroy)
    end
end
