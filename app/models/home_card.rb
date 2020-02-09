class HomeCard < ApplicationRecord
  mount_uploader :avatar, PhotoUploader

  validates :avatar, file_size: { less_than: 2.megabytes }, presence: true
end
