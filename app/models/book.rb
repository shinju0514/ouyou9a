class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  is_impressionable counter_cache: true

  scope :pv ,-> {order("impressions_count DESC")}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
