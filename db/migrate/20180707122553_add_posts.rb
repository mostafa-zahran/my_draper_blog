class AddPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :short_description
      t.text :content
      t.integer :creator_id
      t.timestamps null: false
    end
  end
end
