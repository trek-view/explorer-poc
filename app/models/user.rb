class User < ApplicationRecord

  extend FriendlyId

  # Include default devise modules. Others available are:
  # :lockable,  and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :tours, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :tourbooks, dependent: :destroy
  has_many :guidebooks, dependent: :destroy

  attr_accessor :global_subscribe

  validates_presence_of   :name
  validates_uniqueness_of :name,
                          case_sensitive: false
  validates_format_of :name,
                      with: /\A[a-zA-Z0-9_]*\z/,
                      message: 'should not contain whitespaces or special characters'
  validates_acceptance_of :terms

  validates :name, length: { minimum: 5, maximum: 25 }

  has_secure_token :api_token
  friendly_id :name, use: :slugged
  acts_as_favoritor

  after_create :subscribe_to_global

  before_destroy :delete_from_global

  def subscribe_to_global
    return unless global_subscribe == '1'

    client = MailerLite.client
    return unless client.present?

    begin
      client.create_subscriber(email: email, name: name).call
      group = client.group(ENV['MAILERLITE_GROUP_ID'])
      client.create_group_subscriber(
        group.id, {email: email, fields: {name: name}}
      )
    rescue => exception
      puts "=== exception: #{exception.inspect}"
    end
  end

  def should_generate_new_friendly_id?
    name_changed? || slug.nil?
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def delete_from_global
    # return unless global_subscribe == '1'
    client = MailerLite.client
    return unless Rails.env.production? || Rails.env.staging?
    return unless client.present?
    return unless ENV['MAILERLITE_GROUP_ID']

    # Delete from group
    begin
      group = client.group(ENV['MAILERLITE_GROUP_ID'])
      client.delete_group_subscriber(group.id, email)
    rescue => exception
      puts "=== exception: #{exception.inspect}"
    end

    # Delete from subscribers
    begin
      options = {
        type: :unsubscribed
      }
      client.update_subscriber(email, options)
    rescue => exception
      puts "=== exception: #{exception.inspect}"
    end
  end

  def photos_ids
    ids = []
    tours.map { |t|
      ids = ids + t.photos.ids
    }
    ids.uniq
  end

  def photos
    Photo.where(id: self.photos_ids)
  end
end
