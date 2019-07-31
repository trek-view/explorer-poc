class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Include default devise modules. Others available are:
  # :lockable,  and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :tours
  has_many :subscriptions

  attr_accessor :global_subscribe

  validates :name, presence: true,
            uniqueness: {case_sensitive: false},
            format: { with: /\A[a-zA-Z0-9]*\z/, message: 'should not contain whitespaces or special characters'}
  validates_acceptance_of :terms

  has_secure_token :api_token

  after_create :subscribe_to_global

  def subscribe_to_global
    if global_subscribe
      # self.subscriptions.create!(kind: Constants::SUBSCRIPTION_TYPES[:global])
      Mailchimp::ListUpdater.new(self).call
    end
  end

end
