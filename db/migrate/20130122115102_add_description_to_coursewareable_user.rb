class AddDescriptionToCoursewareableUser < ActiveRecord::Migration
  def change
    add_column :coursewareable_users, :description, :text
  end
end
