class AddReferencesToSponsorships < ActiveRecord::Migration[5.2]
  def change
    add_reference :sponsorships, :tour, foreign_key: true
    add_reference :sponsorships, :sponsor, foreign_key: true
  end
end
