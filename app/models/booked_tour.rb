class BookedTour < ApplicationRecord

  belongs_to :tour
  belongs_to :tour_book

end
