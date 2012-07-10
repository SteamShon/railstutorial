class AddAttachmentPhotoToReviews < ActiveRecord::Migration
  def self.up
    change_table :reviews do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :reviews, :photo
  end
end
