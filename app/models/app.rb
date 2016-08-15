class App < ApplicationRecord
  has_secure_token

  validates :name, length: { in: 4..24 }

  def authorized?(token)
    self.token == token
  end
end
