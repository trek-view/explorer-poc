class Sponsorship < ApplicationRecord
  belongs_to :tour
  belongs_to :sponsor
end
