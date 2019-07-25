# frozen_string_literal: true
module ApplicationHelper

  def current_class?(test_path)
    request.path == test_path ? 'active' : ''
  end

end
