module MapsHelper
  def present_map(map)
    {
      url: map.url,
      embed_url: map.embed_url,
      author: map.author,
      organization: map.organization,
      visualization_id: map.visualization_id,
      published_at: map.published_at
    }
  end
end
