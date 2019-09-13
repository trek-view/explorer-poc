# frozen_string_literal: true
class TourBookPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    p 'pundit check user ============================'
    p user
    user.present?
  end

  def update?
    user && record.user_id == user.id
  end

  def destroy?
    update?
  end

  # def info?
  #   record && user && scope.where(id: record.id).exists? && record.id == user.id
  # end

end