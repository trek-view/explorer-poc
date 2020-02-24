# frozen_string_literal: true
class UserPolicy < ApplicationPolicy

  def generate_new_token?
    user && record.id == user.id
    # info?
  end

  def tours?
    user && record.id == user.id
  end

  def submit_request_apikey?
    user && record.id == user.id
  end
end
