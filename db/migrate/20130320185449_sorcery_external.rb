class SorceryExternal < ActiveRecord::Migration
  def self.up
    create_table :coursewareable_authentications do |t|
      t.integer :user_id, :null => false
      t.string :provider, :uid, :null => false

      t.timestamps
    end
    add_index :coursewareable_authentications, :user_id
  end

  def self.down
    drop_table :coursewareable_authentications
  end
end
