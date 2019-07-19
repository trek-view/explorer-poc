class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Include default devise modules. Others available are:
  # :lockable,  and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :tours

  validates :name, presence: true, uniqueness: {case_sensitive: false},
            format: { with: /\A[a-zA-Z0-9]+\Z/ }

  has_secure_token :api_token

end
