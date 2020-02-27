class ScenePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user && record.guidebook.user_id == user.id
  end

  def destroy?
    update?
  end
end
