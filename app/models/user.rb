class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable,  and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :tours

  validates :name, presence: true, uniqueness: true

  has_secure_token :api_token

end
