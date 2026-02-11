class User < ApplicationRecord
  has_secure_password

  # Has Many Associations
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end