class Card < ActiveRecord::Base
  validates :username, :organization, :visualization_id, :privacy, presence: true
  validates :visualization_id, uniqueness: true
  validates :privacy, inclusion: { in: ['public'] } # don't load link/private vis

  def self.from_event(event)
    indifferent_event = event.with_indifferent_access

    new(username: indifferent_event[:username],
        organization: indifferent_event[:organization],
        visualization_id: indifferent_event[:visualization_id],
        privacy: indifferent_event[:privacy])
  end
end