class Product < ApplicationRecord
  scope :promoted, -> { where(promoted: true) }
  scope :tagged, ->(tag) { where('tags ILIKE ?', "%#{tag}%") }

  validates :title, uniqueness: true

  def self.promote_all!(tag)
  end

  def discount!(percentage)
  end
end
