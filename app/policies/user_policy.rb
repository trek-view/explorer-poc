# frozen_string_literal: true
class UserPolicy < ApplicationPolicy

  def info?
    record && user && scope.where(id: record.id).exists? && record.id == user.id
  end

  def generate_new_token?
    token_info?
  end

  def tours?
    user && record.id == user.id
  end

end
