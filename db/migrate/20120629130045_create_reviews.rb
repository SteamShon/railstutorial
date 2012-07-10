class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.integer :rate
      t.integer :user_id
      t.integer :place_id
      t.string :note
      t.timestamps
    end
  end
end
