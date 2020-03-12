
ISO3166::Country.all.map{|country|
  Country.create!(name: country.name, code: country.alpha2) unless Country.find_by(code: country.alpha2)
}
