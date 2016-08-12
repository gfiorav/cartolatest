class Card < ActiveRecord::Base
  validates :username, :visualization_id, :privacy, presence: true
  validates :visualization_id, uniqueness: true
  validates :privacy, inclusion: { in: ['public'] } # don't load link/private vis

  def self.from_event(event)
    indifferent_event = event.with_indifferent_access

    new(username: indifferent_event[:username],
        organization: indifferent_event[:organization],
        visualization_id: indifferent_event[:vis_id],
        privacy: indifferent_event[:privacy])
  end

  def embed_url
    subdomain = organization.present? ? "#{organization}." : ''

    "https://#{subdomain}carto.com/u/#{username}/builder/#{visualization_id}/embed"
  end
end