# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  has_many :reviews
  has_many :places, :through => :reviews, :uniq => true
  accepts_nested_attributes_for :reviews, :reject_if => lambda { |a| a[:content].blank? }
  #accepts_nested_attributes_for :places

  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  before_save { self.email = self.email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  acts_as_voter
  
  def liked_by_count
    self.reviews.collect{|r| r.votes.size}.inject{|sum, v| sum + v}
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
