class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  attr_accessible :rate, :title, :note, :user_id, :place_id, :photo
  #accepts_nested_attributes_for :place
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  acts_as_votable
end
