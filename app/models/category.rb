class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 }
  has_many :article_categories
  has_many :articles, through: :article_categories
  scope :custom_display, -> { order(:updated_at => :desc) }
end