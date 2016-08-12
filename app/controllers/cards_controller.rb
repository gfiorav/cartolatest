class CardsController < ApplicationController
  before_filter :fetch_latest_published, only: :index
  before_filter :remove_old_cards, only: :index

  MAX_CARDS = 10

  def index
    @cards = Card.order(created_at: :desc)
  end

  private

    def fetch_latest_published
      keen = Keen::Client.new(project_id: Rails.configuration.keen[:project_id],
                              read_key: Rails.configuration.keen[:read_key])

      last_published = keen.extraction('Published map', timeframe: 'this_2_days')

      new_cards = last_published.map do |event|
        Card.from_event(event)
      end

      new_cards.each(&:save)
    end

    def remove_old_cards
      (Card.all - Card.order(created_at: :desc).take(MAX_CARDS)).each(&:destroy)
    end
end
