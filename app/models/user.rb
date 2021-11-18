class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :books
  has_many :comments
  has_many :favorites

  mount_uploader :image, ImageUploader
end
