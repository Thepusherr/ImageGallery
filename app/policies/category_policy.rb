class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        # If user is logged in, show their own categories (including hidden ones) and visible categories from others
        scope.where(user: user).or(scope.where(visibility: :visible))
      else
        # If no user is logged in, only show visible categories
        scope.where(visibility: :visible)
      end
    end
  end

  def show?
    record.visibility == 'hidden' ? (user && record.user == user) : true
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user && (record.user == user || user.admin?)
  end

  def edit?
    update?
  end

  def destroy?
    user && (record.user == user || user.admin?)
  end

  def show_image?
    show?
  end
end
