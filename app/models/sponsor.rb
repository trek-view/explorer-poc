class Sponsor < ApplicationRecord
  has_many :sponsorships

  def tours_ids
    sponsorships.map { |s| s.tour.id }
  end

  def tours
    Tour.where(id: self.tours_ids)
  end
end
