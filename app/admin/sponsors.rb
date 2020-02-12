ActiveAdmin.register Sponsor do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :description, :url, :duration
  form(html: { multipart: true }) do |f|
    f.inputs '' do
      f.input :title
      f.input :description
      f.input :url
      f.input :duration, as: :select, prompt: 'Select a duration type',
        collection: ['1 month', '6 months', '1 year'],
        input_html: { :class => 'chzn-select', :width => 'auto', "data-placeholder" => 'Click' }
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :description, :url, :duration]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
