# frozen_string_literal: true
class BookedTour < ApplicationRecord

  belongs_to :tour, counter_cache: :tourbooks_count
  belongs_to :tourbook

  validates_uniqueness_of :tour_id, scope: :tourbook_id, message: 'has already been added.'

end
