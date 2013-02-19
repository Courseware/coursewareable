class CreateCoursewareableInvitations < ActiveRecord::Migration
  def change
    create_table :coursewareable_invitations do |t|
      t.reference :classroom
      t.reference :creator
      t.reference :user
      t.string :email
      t.string :role

      t.timestamps
    end

    add_index :coursewareable_invitations, :email
    add_index :coursewareable_invitations, :classroom_id
    add_index :coursewareable_invitations, :creator_id
    add_index :coursewareable_invitations, :user_id
  end
end
