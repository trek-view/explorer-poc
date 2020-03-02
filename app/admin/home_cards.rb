ActiveAdmin.register HomeCard do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :description, :priority, :url, :icon

  form(html: { multipart: true }) do |f|
    f.inputs '' do
      f.input :title
      f.input :description
      f.input :priority
      f.input :url
      f.input :icon
    end
    f.actions
  end
end
