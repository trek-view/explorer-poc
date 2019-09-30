class User < ApplicationRecord

  extend FriendlyId

  # Include default devise modules. Others available are:
  # :lockable,  and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :tours, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :tour_books, dependent: :destroy
  has_many :view_points, dependent: :destroy

  attr_accessor :global_subscribe

  validates_presence_of   :name
  validates_uniqueness_of :name,
                          case_sensitive: false
  validates_format_of :name,
                      with: /\A[a-zA-Z0-9]*\z/,
                      message: 'should not contain whitespaces or special characters'
  validates_acceptance_of :terms

  has_secure_token :api_token
  friendly_id :name, use: :slugged

  after_create :subscribe_to_global

  def subscribe_to_global
    if global_subscribe == '1'
      Mailchimp::ListUpdater.new(self).call
    end
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

end
