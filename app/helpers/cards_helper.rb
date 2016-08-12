module CardsHelper
  def present_card(card)
    {
      url: card.url,
      embed_url: card.embed_url,
      username: card.username,
      organization: card.organization,
      visualization_id: card.visualization_id,
      published_at: card.published_at
    }
  end
end
