class BookedTour < ApplicationRecord

  belongs_to :tour
  belongs_to :tour_book

  validates_uniqueness_of :tour_id, scope: :tour_book_id, message: 'has already been added.'

end
