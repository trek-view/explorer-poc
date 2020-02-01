class Category < ApplicationRecord
  has_many :guidebooks, dependent: :destroy
end
