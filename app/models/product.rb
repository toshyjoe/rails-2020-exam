class Product < ApplicationRecord
  scope :promoted, -> { where(promoted: true) }
  scope :tagged, ->(tag) { where('tags ILIKE ?', "%#{tag}%") }

  validates :title, uniqueness: true
  validates :title, presence: true

  def self.promote_all!(tag)
    tagged(tag).update_all(promoted: true)
  end

  def discount!(percentage)
    update!(
      price: price - (price * percentage/100),
      title: percentage > 0 ? "#{title} 💥" : title)
  end
end
