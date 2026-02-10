class User < ApplicationRecord
  has_secure_password

  # Has Many Associations
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end