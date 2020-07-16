class Product < ApplicationRecord
	validates :title, :description, :image_url, presence: true
	validates :price, numericality: { greater_than_or_equal_to: 0.01 }
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: {
		with: /\.(gif|jpg|png)\z/i,
		message: 'must be a URL for a GIF, JPG or PNG image.'
	}
	validates :description, length: { minimum: 10, too_short: 'must be at least 10 characters long.' }
end
