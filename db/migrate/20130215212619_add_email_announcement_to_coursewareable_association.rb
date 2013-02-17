class AddEmailAnnouncementToCoursewareableAssociation < ActiveRecord::Migration
  def change
    add_column :coursewareable_associations, :email_announcement, :string
  end
end
