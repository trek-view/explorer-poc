ActiveAdmin.register HomeCard do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :description, :priority, :url, :avatar, :avatar_cache

  form(html: { multipart: true }) do |f|
    f.inputs 'Create a home card...' do
      f.input :title
      f.input :description
      f.input :priority
      f.input :url
      f.input :avatar, as: :file, hint: f.object.avatar.present? ? \
                f.image_tag(f.object.avatar.url(:thumb)) : \
                f.content_tag(:span, 'No avatar yet')
      f.input :avatar_cache, as: :hidden
    end
    f.actions
  end
end
