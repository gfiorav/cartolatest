require 'carto_latest/metrics'

class CardsController < ApplicationController
  before_filter :fetch_latest_published, only: :index, if: :refresh_possible
  after_filter :remove_old_cards, only: :index

  COLUMNS = 3
  ROWS = 4
  CARDS = COLUMNS * ROWS

  MIN_TIME_FOR_REFRESH = 5.minutes

  def index
    @cards = Card.order(created_at: :desc).take(CARDS)
    @columns = COLUMNS
    @rows = ROWS
  end

  private

    def refresh_possible
      Time.now.utc - Card.order(created_at: :desc).first.created_at > MIN_TIME_FOR_REFRESH
    end

    def fetch_latest_published
      new_cards = CartoLatest::Metrics.new.latest_published.map { |event| Card.from_event(event) }

      new_cards.each(&:save)
    end

    def remove_old_cards
      (Card.all - Card.order(created_at: :desc).take(CARDS)).each(&:destroy)
    end
end
