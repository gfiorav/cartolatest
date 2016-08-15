class App < ApplicationRecord
  has_secure_token :app_id
  has_secure_token :app_key

  validates :name, length: { in: 4..24 }

  def authorized?(id, key)
    app_id == id && app_key == key
  end
end
