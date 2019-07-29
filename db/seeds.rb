user = User.new(name: 'Johnny', email: 'exp-admin@example.com', password: 'password', password_confirmation: 'password')
user.skip_confirmation!
user.save!

user.tours.create!(name: 'England tour',
                 description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.',
                 country_name: 'England',
                 tag_names: 'cheese, vine, fog',
                 local_id: '11',
                 google_link: 'https://truetube.com',
                 tour_type: 'water')

user.tours.create!(name: 'Holland tour',
                 description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.',
                 country_name: 'England',
                 tag_names: 'joy, fun, fog',
                 local_id: '12',
                 google_link: 'https://falsetube.com',
                 tour_type: 'air')

user.tours.create!(name: 'Germany tour',
                 description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.',
                 country_name: 'Germany',
                 tag_names: 'auto, grass, trees',
                 local_id: '13',
                 google_link: 'https://zerotube.com',
                 tour_type: 'air')

user.tours.create!(name: 'West tour',
                 description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.',
                 country_name: 'Italy',
                 tag_names: 'leather, boots, vine',
                 local_id: '14',
                 google_link: 'https://google.com',
                 tour_type: 'land')

