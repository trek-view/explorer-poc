ActiveAdmin.register Sponsorship do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :tour_id, :sponsor_id

  form(html: { multipart: true }) do |f|
    f.inputs '' do
      f.input :tour_id, as: :select, prompt: 'Select a tour',
        collection: Tour.all,
        input_html: { :class => 'chzn-select', :width => 'auto', "data-placeholder" => 'Click' }
      f.input :sponsor_id, as: :select, prompt: 'Select a sponsor',
        collection: Sponsor.all,
        input_html: { :class => 'chzn-select', :width => 'auto', "data-placeholder" => 'Click' }
    end
    f.actions
  end
end
