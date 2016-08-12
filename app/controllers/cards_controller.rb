require 'carto_latest/metrics'

class CardsController < ApplicationController
  before_filter :fetch_latest_published, only: :index
  after_filter :remove_old_cards, only: :index

  CARDS = 16

  MIN_TIME_FOR_REFRESH = 5.minutes

  def index
    @cards = Card.order(created_at: :desc).take(CARDS)
  end

  private

    def fetch_latest_published
      new_cards = CartoLatest::Metrics.new.latest_published.map { |event| Card.from_event(event) }

      new_cards.each(&:save)
    end

    def remove_old_cards
      (Card.all - Card.order(created_at: :desc).take(CARDS)).each(&:destroy)
    end
end
