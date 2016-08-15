class Map < ActiveRecord::Base
  validates :username, :visualization_id, :privacy, :published_at, presence: true
  validates :visualization_id, uniqueness: true
  validates :privacy, inclusion: { in: ['public'] } # don't load link/private vis

  def self.from_event(event)
    indifferent_event = event.with_indifferent_access

    new(username: indifferent_event[:username],
        organization: indifferent_event[:organization],
        visualization_id: indifferent_event[:vis_id],
        privacy: indifferent_event[:privacy],
        published_at: indifferent_event[:creation_time])
  end

  def self.latest_updated
    order(created_at: :desc).take(1).created_at
  end

  def embed_url
    subdomain = organization.present? ? organization : username

    "https://#{subdomain}.carto.com/u/#{username}/builder/#{visualization_id}/embed"
  end

  def url
    template_name = "tpl_#{visualization_id.gsub('-','_')}"

    "https://#{username}.carto.com/api/v1/map/static/named/#{template_name}/{X}/{Y}.png"
  end
end