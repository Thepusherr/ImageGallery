class View < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  before_create :set_viewed_at

  private

  def set_viewed_at
    self.viewed_at = Time.current
  end
end
